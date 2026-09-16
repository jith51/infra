# frozen_string_literal: true

module App
  module Physical
    module Arguments
      # ComponentSlotArguments
      class ComponentSlot < ::Types::BaseInputObject
        graphql_name 'ComponentSlotInput'

        argument :id, ID, required: false
        argument :name, String, required: true
        argument :description, String, required: false
        argument :component_type_id, ID, required: false
      end
    end
  end
end
