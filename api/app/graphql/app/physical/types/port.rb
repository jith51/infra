# frozen_string_literal: true

module App
  module Physical
    module Types
      # PortType
      class Port < ::Types::BaseObject
        graphql_name 'PortTypeT'

        field :id, ID, null: true
        field :name, String, null: false
        field :port_type_id, ID, null: true
        field :description, String, null: true
        field :mac_address, String, null: true
        field :connection, Physical::Types::Connection, null: true
      end
    end
  end
end
