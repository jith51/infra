# frozen_string_literal: true

module App
  module Physical
    module Arguments
      # ChassisClassArguments
      class ChassisClass < ::Types::BaseInputObject
        graphql_name 'ChassisClassInput'

        argument :id, ID, required: false
        argument :name, String, required: true
        argument :chassis_powertype_id, String, required: false
        argument :fournisseur, String, required: false
        argument :model, String, required: false
        argument :part_number, String, required: false
        argument :vendor_equipment_type, String, required: false
        argument :version, String, required: false
        argument :height, Integer, required: false
        argument :url_link, String, required: false
        argument :front_image, ::Types::FileType, required: false
        argument :back_image, ::Types::FileType, required: false
        argument :custom_attributes, GraphQL::Types::JSON, required: false
        argument :custom_attributes_definition, [::App::Physical::Arguments::CustomAttributesDefinition], required: false
        argument :component_slots, [::App::Physical::Arguments::ComponentSlot], required: false, as: :component_slots_attributes, prepare: ->(value, _ctx) { value.map(&:to_h) }
        argument :port_slots, [::App::Physical::Arguments::PortSlot], required: false, as: :port_slots_attributes, prepare: ->(value, _ctx) { value.map(&:to_h) }
      end
    end
  end
end
