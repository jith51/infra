# frozen_string_literal: true

module App
  module Physical
    module Types
      # ComponentSlotType
      class ComponentSlot < ::Types::BaseObject
        graphql_name 'ComponentSlotType'

        field :id, ID, null: true
        field :name, String, null: false
        field :component_type_id, ID, null: true
        field :description, String, null: true
      end
    end
  end
end
