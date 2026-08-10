# frozen_string_literal: true

module App
  module Physical
    module Arguments
      # PortTypeArgument
      class PortType < ::Types::BaseInputObject
        graphql_name 'PortTypeInput'

        argument :id, ID, required: false
        argument :name, String, required: true
      end
    end
  end
end
