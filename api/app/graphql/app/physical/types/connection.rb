# frozen_string_literal: true

module App
  module Physical
    module Types
      # ConnectionType
      class Connection < ::Types::BaseObject
        graphql_name 'ConnectionType'

        field :id, ID, null: true
        field :distant_id, ID, null: false
        field :link_type_id, ID, null: true
      end
    end
  end
end