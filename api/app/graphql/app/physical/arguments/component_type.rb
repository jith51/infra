# frozen_string_literal: true

module App
  module Physical
    module Arguments
      # ComponentTypeArgument
      class ComponentType < ::Types::BaseInputObject
        graphql_name 'ComponentTypeInput'

        argument :id, ID, required: false
        argument :name, String, required: true
      end
    end
  end
end
