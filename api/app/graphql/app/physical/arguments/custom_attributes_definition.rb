# frozen_string_literal: true

module App
  module Physical
    module Arguments
      # CustomAttributesDefinitionArguments
      class CustomAttributesDefinition< ::Types::BaseInputObject
        graphql_name 'CustomAttributesDefinitionInput'

        argument :name, String, required: true
        argument :label, String, required: true
        argument :type, String, required: true
      end
    end
  end
end
