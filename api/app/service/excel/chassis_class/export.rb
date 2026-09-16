# frozen_string_literal: true

require 'axlsx'

module Excel
  module ChassisClass
    # ChassisClass Export
    class Export
      include Constants

      def initialize(struct_only:, chassis_powertype_id: nil)
        @struct_only = struct_only
        @chassis_powertype_id = chassis_powertype_id
      end

      def build
        package = Axlsx::Package.new
        @workbook = package.workbook
        @sheets = {}
        @headers = HEADERS

        build_sheets
        fill_sheets unless struct_only

        package.to_stream.read
      end

      private

      attr_reader :struct_only, :chassis_powertype_id

      def build_sheets
        build_chassis_classes_sheet
        build_powertype_sheets
        build_custom_attributes_definition_sheet
        build_component_slots_sheet
        build_port_slots_sheet
      end

      def build_chassis_classes_sheet
        @sheets['chassis_classes'] = @workbook.add_worksheet(name: 'chassis_classes')
        @sheets['chassis_classes'].add_row(@headers['chassis_classes'])
      end

      def build_powertype_sheets
        powertypes = chassis_powertype_id.present? ? [::Physical::ChassisPowertype.find(chassis_powertype_id)] : ::Physical::ChassisPowertype.all
        powertypes.each do |powertype|
          next if @headers[powertype.name].blank?

          @sheets[powertype.name] = @workbook.add_worksheet(name: powertype.name)

          @sheets[powertype.name].add_row(@headers[powertype.name])
        end
      end

      def build_custom_attributes_definition_sheet
        @sheets['CustomAttributesDefinition'] = @workbook.add_worksheet(name: 'CustomAttributesDefinition')
        @sheets['CustomAttributesDefinition'].add_row(@headers['CustomAttributesDefinition'])
      end

      def build_component_slots_sheet
        @sheets['Composants'] = @workbook.add_worksheet(name: 'Composants')
        @sheets['Composants'].add_row(@headers['Composants'])
      end

      def build_port_slots_sheet
        @sheets['Ports'] = @workbook.add_worksheet(name: 'Ports')
        @sheets['Ports'].add_row(@headers['Ports'])
      end

      def fill_sheets
        scope = Physical::ChassisClass.includes(
          :chassis_powertype,
          component_slots: :component_type,
          port_slots: :port_type
        )

        scope = scope.where(chassis_powertype_id: chassis_powertype_id) if chassis_powertype_id.present?

        scope.find_each do |chassis_class|
          add_chassis_class_row(chassis_class)
          add_custom_attributes_row(chassis_class)
          add_custom_attributes_definition_rows(chassis_class)
          add_component_slot_rows(chassis_class)
          add_port_slot_rows(chassis_class)
        end
      end

      def add_chassis_class_row(chassis_class)
        attributes = chassis_class.attributes.merge('type' => chassis_class.chassis_powertype&.name)
        add_row('chassis_classes', attributes)
      end

      def add_custom_attributes_row(chassis_class)
        return if chassis_class.chassis_powertype_id.blank?
        return if chassis_class.custom_attributes.blank?

        attributes = chassis_class.custom_attributes.merge('chassis_class_name' => chassis_class.name)
        add_row(chassis_class.chassis_powertype.name, attributes)
      end

      def add_custom_attributes_definition_rows(chassis_class)
        return if chassis_class.custom_attributes_definition.blank?

        chassis_class.custom_attributes_definition.each do |name, attrs|
          attributes = attrs.merge('name' => name, 'chassis_class_name' => chassis_class.name)
          add_row('CustomAttributesDefinition', attributes)
        end
      end

      def add_component_slot_rows(chassis_class)
        chassis_class.component_slots.each do |component|
          attributes = component.attributes.merge(
            'chassis_class_name' => chassis_class.name, 'type' => component.component_type&.name
          )
          add_row('Composants', attributes)
        end
      end

      def add_port_slot_rows(chassis_class)
        chassis_class.port_slots.each do |port|
          attributes = port.attributes.merge(
            'chassis_class_name' => chassis_class.name, 'type' => port.port_type&.name
          )
          add_row('Ports', attributes)
        end
      end

      def add_row(sheet_name, attributes)
        @sheets[sheet_name].add_row(
          @headers[sheet_name].map { |header| attributes[header] }
        )
      end
    end
  end
end
