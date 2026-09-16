# frozen_string_literal: true

module App
  module Physical
    module Types
      # PortType Type
      class AvailablePort < ::Types::BaseObject
        graphql_name 'AvailablePortType'

        field :id, ID, null: true
        field :name, String, null: false
      end
    end
  end
end
