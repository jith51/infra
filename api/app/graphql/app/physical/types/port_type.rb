# frozen_string_literal: true

module App
  module Physical
    module Types
      # PortType Type
      class PortType < ::Types::BaseObject
        graphql_name 'PortTypeType'

        field :id, ID, null: true
        field :name, String, null: false
      end
    end
  end
end
