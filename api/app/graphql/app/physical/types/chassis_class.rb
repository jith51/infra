# frozen_string_literal: true

module App
  module Physical
    module Types
      # ChassisClassType
      class ChassisClass < ::Types::BaseObject
        graphql_name 'ChassisClassType'

        implements ::App::Physical::Types::Interfaces::ChassisClassInterface

        field :chassis_powertype_id, String, null: true
        field :chassis_powertype, ::App::Physical::Types::ChassisPowertype
        field :fournisseur, String, null: true
        field :model, String, null: true
        field :part_number, String, null: true
        field :vendor_equipment_type, String, null: true
        field :version, String, null: true
        field :height, Integer, null: true
        field :url_link, String, null: true
        field :front_image, String, null: true
        field :back_image, String, null: true
        field :custom_attributes, GraphQL::Types::JSON, null: false
        # Field suivant pour récupérer toutes les définitions des custom attributes
        field :all_custom_attributes_definition, GraphQL::Types::JSON, null: false
        field :custom_attributes_definition, [GraphQL::Types::JSON], null: false
        field :component_slots, [::App::Physical::Types::ComponentSlot]
        field :port_slots, [::App::Physical::Types::PortSlot]

        # def front_image
        #   object.front_image_url_path
        # end

        # def back_image
        #   object.back_image_url_path
        # end

        def custom_attributes_definition
          # On passe de {key1: {label:'', type:''}, key2: {label:'', type:''}}
          # à [{name: key1, label:'', type:''}, {name: key2, label:'', type:''}]
          object.custom_attributes_definition.map do |name, attrs|
            attrs.symbolize_keys.merge(name: name)
          end
        end

        def all_custom_attributes_definition
          # On passe tous les ca sous la forme {key1: {label:'', type:''}, key2: {label:'', type:''}}
          chassis_powertypes = object.chassis_powertype&.self_and_ancestors || []
          chassis_powertypes.map(&:custom_attributes_definition).reduce({}, & :merge)
        end
      end
    end
  end
end
