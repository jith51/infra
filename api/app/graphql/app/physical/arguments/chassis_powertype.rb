# frozen_string_literal: true

module App
  module Physical
    module Arguments
      # ChassisPowertypeArguments
      class ChassisPowertype < ::Types::BaseInputObject
        graphql_name 'ChassisPowertypeInput'

        argument :id, String, required: false
        argument :name, String, required: true
        argument :parent_id, String, required: false
        argument :custom_attributes, [::App::Physical::Arguments::CustomAttribute], required: false
      end
    end
  end
end
