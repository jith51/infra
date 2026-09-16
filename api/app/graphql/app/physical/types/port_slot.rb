# frozen_string_literal: true

module App
  module Physical
    module Types
      # PortSlotType
      class PortSlot < ::Types::BaseObject
        graphql_name 'PortSlotType'

        field :id, ID, null: true
        field :name, String, null: false
        field :port_type_id, ID, null: true
        field :description, String, null: true
      end
    end
  end
end
