# frozen_string_literal: true

module App
  module Physical
    module Arguments
      # ComponentArguments
      class Component < ::Types::BaseInputObject
        graphql_name 'ComponentInput'

        argument :id, ID, required: false
        argument :name, String, required: true
        argument :serial_number, String, required: false
        argument :description, String, required: false
        argument :component_type_id, ID, required: false
      end
    end
  end
end
