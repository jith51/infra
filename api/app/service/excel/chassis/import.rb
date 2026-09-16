# frozen_string_literal: true

require 'roo'

module Excel
  module Chassis
    # Class d'erreur
    class ExcelImportError < StandardError
      attr_reader :errors

      def initialize(errors)
        @errors = errors
        super("Erreur lors de l'import")
      end
    end

    # ChassisClass Import
    class Import
      include Constants

      def initialize(uploaded_file)
        # @spreadsheet = Roo::Spreadsheet.open(StringIO.new(file), extension: :xlsx)
        @spreadsheet = Roo::Spreadsheet.open(uploaded_file.tempfile, extension: :xlsx)
      end

      def call
        validate!

        ActiveRecord::Base.transaction do
          import_data
        end
      end

      private

      attr_reader :spreadsheet

      def validate!
        ExcelValidator.new(spreadsheet).validate!
      rescue Excel::Chassis::ExcelValidator::ValidationError => e
        raise ExcelImportError, [
          {
            error: e.message
          }
        ]
      end

      def import_data
        errors = []
        datas = workbook_to_h

        chassis = datas.delete('Chassis')

        all_chassis = ::Physical::Chassis.pluck(:name, :id).to_h
        chassis_classes = ::Physical::ChassisClass.pluck(:name, :id).to_h
        component_types = ::Physical::ComponentType.pluck(:name, :id).to_h
        port_types = ::Physical::PortType.pluck(:name, :id).to_h
        link_types = ::Physical::LinkType.pluck(:name, :id).to_h

        chassis.each_with_index do |c, index|
          build_chassis(c, datas, chassis_classes, all_chassis, component_types, port_types, link_types)
        rescue StandardError => e
          Rails.logger.error e.full_message
          errors << {
            row: index + 2, # +2 car ligne 1 = headers
            chassis: c['name'],
            data: c,
            error: e.message
          }
        end

        raise ExcelImportError, errors if errors.any?
      end

      def build_chassis(chassis, datas, chassis_classes, all_chassis, component_types, port_types, link_types)
        object = Physical::Chassis.find_or_initialize_by(name: chassis['name'])
        chassis['chassis_class_id'] = chassis_classes[chassis['chassis_class_name']]
        chassis['custom_attributes'] = build_custom_attributes(datas, chassis['name'], chassis_classes['chassis_class_name'])
        chassis['components_attributes'] = build_components_attributes(object, datas, component_types)
        chassis['ports_attributes'] = build_ports_attributes(object, datas, port_types, link_types, all_chassis)
        chassis = ::NestedAttributes.prepare_nested_attributes(object, chassis, 'components_attributes', 'ports_attributes')
        chassis.delete('chassis_class_name')
        object.update!(chassis)
      end

      def build_custom_attributes(datas, chassis_name, chassis_class_sheet_name)
        custom_attributes = datas[chassis_class_sheet_name]&.find { |p| p['chassis_name'] == chassis_name }
        custom_attributes&.except('chassis_name') || {}
      end

      def build_components_attributes(object, datas, component_types)
        attributes = datas['Composants']&.select { |c| c['chassis_name'] == object.name } || []
        attributes.map do |c|
          c.merge(
            {
              'component_type_id' => component_types[c['type']],
              'id' => object.components.find_by(name: c['name'])&.id
            }
          ).except('chassis_name', 'type')
        end
      end

      def build_ports_attributes(object, datas, port_types, link_types, all_chassis)
        attributes = datas['Ports']&.select { |c| c['chassis_name'] == object.name } || []
        attributes.map do |c|
          port = object.ports.find_by(name: c['name'])
          connections_attributes = build_connection_attributes(c, port, all_chassis, link_types)
          c['connection_attributes'] = connections_attributes unless connections_attributes.blank?
          c.merge(
            {
              'port_type_id' => port_types[c['type']],
              'id' => object.ports.find_by(name: c['name'])&.id,
            }
          ).except('chassis_name', 'type', 'chassis_connected', 'port_connected', 'link_type')
        end
      end

      def build_connection_attributes(object, port, all_chassis, link_types)
        # On récupere l'id du port du chassis connecté
        chassis_connected_id = all_chassis[object['chassis_connected']]
        distant_port_id = Physical::Port.find_by(name: object['port_connected'], chassis_id: chassis_connected_id)&.id
        if distant_port_id.present?
          # si port existant
          return {
            'id' => port.id,
            'distant_port_id' => distant_port_id,
            'link_type_id' => link_types[object['link_type']]
          }
        elsif port.connection.present?
          # si port inexistant et connection existante en base on la marque pour destrcution
          return {
            '_destroy' => true,
            'id' => port.id,
            'distant_port_id' => port.connection.distant_port_id
          }
        end
        # Dans les autres cas
        nil
      end

      def workbook_to_h
        HEADERS.keys.each_with_object({}) do |sheet_name, r|
          sheet = spreadsheet.sheet(sheet_name)
          headers = sheet.row(1).map(&:to_s)
          r[sheet_name] = sheet_to_h(sheet, headers)
        end
      end

      def sheet_to_h(sheet, headers)
        rows = []
        sheet.each_row_streaming(offset: 1, pad_cells: true) do |row|
          values = row.map { |cell| cell&.value }
          next if values.all?(&:blank?)

          rows << headers.zip(values).to_h
        end
        rows
      end
    end

    # Class de validation
    class ExcelValidator
      include Constants

      class ValidationError < StandardError; end

      attr_reader :spreadsheet

      def initialize(spreadsheet)
        @spreadsheet = spreadsheet
      end

      def validate!
        sheet_valid!
        headers_valid!

        true
      end

      def sheet_valid!
        existing_sheets = spreadsheet.sheets
        expected_sheets = BASE_SHEETS + CHASSIS_CLASS_SHEETS

        extra_sheets = existing_sheets - expected_sheets
        missing_sheets = BASE_SHEETS - existing_sheets

        return true if extra_sheets.empty? && missing_sheets.empty?

        raise ValidationError, <<~ERROR
          Onglets invalides.
          Inattendus :  #{extra_sheets.join(', ')}
          Manquants :  #{missing_sheets.join(', ')}
        ERROR
      end

      def headers_valid!
        HEADERS.each do |sheet_name, expected_headers|
          sheet = spreadsheet.sheet(sheet_name)

          existing_headers = sheet.row(1).compact.map { |header| header.to_s.strip }

          next if existing_headers == expected_headers

          raise ValidationError, <<~ERROR
            Headers invalides dans l'onglet #{sheet_name}.
            Attendus : #{expected_headers.join(', ')}
            Trouvés  : #{existing_headers.join(', ')}
          ERROR
        end
      end
    end
  end
end
