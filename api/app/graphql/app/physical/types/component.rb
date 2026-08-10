# frozen_string_literal: true

module App
  module Physical
    module Types
      # ComponentType
      class Component < ::Types::BaseObject
        graphql_name 'ComponentTypeT'

        field :id, ID, null: true
        field :name, String, null: false
        # field :chassis_id, ID, null: true
        field :component_type_id, ID, null: true
        field :description, String, null: true
        field :serial_number, String, null: true
      end
    end
  end
end
