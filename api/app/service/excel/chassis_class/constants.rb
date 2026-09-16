# frozen_string_literal: true

module Excel
  module ChassisClass
    # Définition des constantes
    module Constants
      HEADERS = ::Physical::ChassisPowertype.find_each.each_with_object(
        {
          'chassis_classes' => (['type'] + ::Physical::ChassisClass.attribute_names.excluding(
            'id',
            'created_at',
            'updated_at',
            'custom_attributes',
            'custom_attributes_definition',
            'chassis_powertype_id',
            'chassis_class_id'
          )),
          'CustomAttributesDefinition' => %w[chassis_class_name name type label],
          'Composants' => %w[chassis_class_name name type description],
          'Ports' => %w[chassis_class_name name type description]
        }
      ) do |powertype, headers|
        attributes = powertype.self_and_ancestors.flat_map { |r| r.custom_attributes_definition.keys }
        next if attributes.empty?

        headers[powertype.name] = ['chassis_class_name'] + attributes
      end.freeze

      BASE_SHEETS = %w[Chassis CustomAttributes Composants Ports].freeze

      POWERTYPES_SHEETS = HEADERS.reject { |sheet_name, _headers| BASE_SHEETS.include?(sheet_name) }.keys.freeze
    end
  end
end
