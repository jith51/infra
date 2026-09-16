# frozen_string_literal: true

require 'axlsx'

module Excel
  module Chassis
    # ChassisClass Export
    class Export
      include ::Excel::Chassis::Constants

      def initialize(struct_only:, chassis_class_id: nil)
        @struct_only = struct_only
        @chassis_class_id = chassis_class_id
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

      attr_reader :struct_only, :chassis_class_id

      def build_sheets
        build_chassis_sheet
        build_chassis_class_sheets
        build_components_sheet
        build_ports_sheet
      end

      def build_chassis_sheet
        @sheets['Chassis'] = @workbook.add_worksheet(name: 'Chassis')
        @sheets['Chassis'].add_row(@headers['Chassis'])
      end

      def build_chassis_class_sheets
        chassis_classes = chassis_class_id.present? ? [::Physical::ChassisClass.find(chassis_class_id)] : ::Physical::ChassisClass.all
        chassis_classes.each do |chassis_class|
          next if @headers[chassis_class.name].blank?

          @sheets[chassis_class.name] = @workbook.add_worksheet(name: chassis_class.name)
          @sheets[chassis_class.name].add_row(@headers[chassis_class.name])
        end
      end

      def build_components_sheet
        @sheets['Composants'] = @workbook.add_worksheet(name: 'Composants')
        @sheets['Composants'].add_row(@headers['Composants'])
      end

      def build_ports_sheet
        @sheets['Ports'] = @workbook.add_worksheet(name: 'Ports')
        @sheets['Ports'].add_row(@headers['Ports'])
      end

      def fill_sheets
        scope = Physical::Chassis.includes(
          :chassis_class,
          components: :component_type,
          ports: [
            :port_type,
            connection: [
              :link_type,
              distant_port: :chassis
            ]
          ]
        )

        scope = scope.where(chassis_class_id: chassis_class_id) if chassis_class_id.present?

        scope.find_each do |chassis|
          add_chassis_class_row(chassis)
          add_custom_attributes_row(chassis)
          add_component_rows(chassis)
          add_port_rows(chassis)
        end
      end

      def add_chassis_class_row(chassis)
        attributes = chassis.attributes.merge('chassis_class_name' => chassis.chassis_class&.name)
        add_row('Chassis', attributes)
      end

      def add_custom_attributes_row(chassis)
        return if chassis.chassis_class_id.blank?
        return if chassis.custom_attributes.blank?

        attributes = chassis.custom_attributes.merge('chassis_name' => chassis.name)
        add_row(chassis.chassis_class.name, attributes)
      end

      def add_component_rows(chassis)
        chassis.components.each do |component|
          attributes = component.attributes.merge(
            'chassis_name' => chassis.name, 'type' => component.component_type&.name
          )
          add_row('Composants', attributes)
        end
      end

      def add_port_rows(chassis_class)
        chassis_class.ports.each do |port|
          attributes = port.attributes.merge(
            'chassis_name' => chassis_class.name,
            'type' => port.port_type&.name,
            'chassis_connected' => port&.connection&.distant_port&.chassis&.name,
            'port_connected' => port&.connection&.distant_port&.name,
            'link_type' => port&.connection&.link_type&.name
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
