# frozen_string_literal: true

module Excel
  module Chassis
    # Définition des constantes
    module Constants
      HEADERS = ::Physical::ChassisClass.find_each.each_with_object(
        {
          'Chassis' => (['chassis_class_name'] + ::Physical::Chassis.attribute_names.excluding(
            'id',
            'created_at',
            'updated_at',
            'custom_attributes',
            'chassis_class_id'
          )),
          'Composants' => %w[chassis_name name type description serial_number],
          'Ports' => %w[chassis_name name type description chassis_connected port_connected link_type]
        }
      ) do |chassis_class, headers|
        attributes = chassis_class.custom_attributes_definition.keys
        next if attributes.empty?

        headers[chassis_class.name] = ['chassis_name'] + attributes
      end.freeze

      BASE_SHEETS = %w[Chassis Composants Ports].freeze

      CHASSIS_CLASS_SHEETS = HEADERS.reject { |sheet_name, _headers| BASE_SHEETS.include?(sheet_name) }.keys.freeze
    end
  end
end
