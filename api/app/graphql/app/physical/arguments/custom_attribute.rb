# frozen_string_literal: true

module App
  module Physical
    module Arguments
      # CustomAttributeArguments
      class CustomAttribute < ::Types::BaseInputObject
        graphql_name 'CustomAttributeInput'

        argument :name, String, required: true
        argument :label, String, required: true
        argument :type, String, required: true
      end
    end
  end
end
