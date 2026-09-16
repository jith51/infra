# frozen_string_literal: true

module App
  module Common
    module Arguments
      # TagArgument
      class Tag < ::Types::BaseInputObject
        graphql_name 'TagInput'

        argument :id, ID, required: false
        argument :name, String, required: true
      end
    end
  end
end
