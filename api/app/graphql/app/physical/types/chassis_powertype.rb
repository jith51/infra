# frozen_string_literal: true

module App
  module Physical
    module Types
      # ChassisType
      class ChassisPowertype < ::Types::BaseObject
        graphql_name 'ChassisPowertypeType'

        field :id, ID, null: false
        field :type, String, null: true
        field :name, String, null: false
        field :parent_id, ID, null: true
        field :custom_attributes, [GraphQL::Types::JSON], null: true
        field :chassis_classes_number, Integer, null: true

        def custom_attributes
          # On passe de {key1: {label:'', type:''}, key2: {label:'', type:''}}
          # à [{name: key1, label:'', type:''}, {name: key2, label:'', type:''}]
          object.custom_attributes.map do |name, attrs|
            attrs.symbolize_keys.merge(name: name)
          end
        end

        def chassis_classes_number
          object.chassis_classes_number
        end
      end
    end
  end
end
