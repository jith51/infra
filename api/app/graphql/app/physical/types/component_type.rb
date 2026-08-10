# frozen_string_literal: true

module App
  module Physical
    module Types
      # ComponentType Type
      class ComponentType < ::Types::BaseObject
        graphql_name 'ComponentTypeType'

        field :id, ID, null: true
        field :name, String, null: false
      end
    end
  end
end
