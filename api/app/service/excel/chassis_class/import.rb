# frozen_string_literal: true

require 'roo'

module Excel
  module ChassisClass
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
      rescue Excel::ExcelValidator::ValidationError => e
        raise "Import impossible : #{e.message}"
      end

      def import_data
        errors = []
        datas = workbook_to_h
        puts datas
        puts 'jhmkjkhhkm'
        chassis_classes = datas.delete('chassis_classes')
        puts 'jhmkjkhhkm'
        puts datas
        puts chassis_classes
        puts 'jhmkjkhhkm'
        powertypes = ::Physical::ChassisPowertype.pluck(:name, :id).to_h
        component_types = ::Physical::ComponentType.pluck(:name, :id).to_h
        port_types = ::Physical::PortType.pluck(:name, :id).to_h

        chassis_classes.each_with_index do |chassis_class, index|
          build_chassis_class(chassis_class, datas, powertypes, component_types, port_types)
          # upsert_chassis_class(chassis_class)s
        rescue StandardError => e
          Rails.logger.error e.full_message
          errors << {
            row: index + 2, # +2 car ligne 1 = headers
            chassis_class: chassis_class['name'],
            data: chassis_class,
            error: e.message
          }
        end

        raise ExcelImportError, errors if errors.any?
      end

      def build_chassis_class(chassis_class, datas, powertypes, component_types, port_types)
        object = Physical::ChassisClass.find_or_initialize_by(name: chassis_class['name'])
        chassis_class['chassis_powertype_id'] = powertypes[chassis_class['type']]
        chassis_class['custom_attributes'] = build_custom_attributes(datas, chassis_class['name'], chassis_class['type'])
        chassis_class['components_attributes'] = build_components_attributes(object, datas, component_types, chassis_class['name'])
        chassis_class['ports_attributes'] = build_ports_attributes(object, datas, port_types, chassis_class['name'])
        chassis_class['custom_attributes_definition'] = build_custom_attributes_definition(datas, chassis_class['name'])
        chassis_class.delete('type')
        object.update!(chassis_class)
      end

      def build_custom_attributes_definition(datas, chassis_class_name)
        cad = datas['CustomAttributesDefinition'].select { |c| c['chassis_class_name'] == chassis_class_name } || []
        cad.each_with_object({}) do |custom_attibute, hash|
          hash[custom_attibute['name']] = custom_attibute.except('chassis_class_name', 'name')
        end
      end

      def build_custom_attributes(datas, chassis_class_name, powertype_sheet_name)
        custom_attributes = datas[powertype_sheet_name]&.find { |p| p['chassis_class_name'] == chassis_class_name }
        custom_attributes&.except('chassis_class_name') || {}
      end

      def build_components_attributes(object, datas, component_types, chassis_class_name)
        attributes = datas['Composants']&.select { |c| c['chassis_class_name'] == chassis_class_name } || []
        attributes.map do |c|
          c.merge(
            {
              'component_type_id' => component_types[c['type']],
              'id' => object.components.find_by(name: c['name'])&.id
            }
          ).except('chassis_class_name', 'type')
        end
      end

      def build_ports_attributes(object, datas, port_types, chassis_class_name)
        attributes = datas['Ports']&.select { |c| c['chassis_class_name'] == chassis_class_name } || []
        attributes.map do |c|
          c.merge(
            {
              'port_type_id' => port_types[c['type']],
              'id' => object.ports.find_by(name: c['name'])&.id
            }
          ).except('chassis_class_name', 'type')
        end
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
        expected_sheets = BASE_SHEETS + POWERTYPES_SHEETS

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
