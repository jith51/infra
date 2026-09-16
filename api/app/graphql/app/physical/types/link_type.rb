# frozen_string_literal: true

module App
  module Physical
    module Types
      # LinkType Type
      class LinkType < ::Types::BaseObject
        graphql_name 'LinkTypeType'

        field :id, ID, null: true
        field :name, String, null: false
      end
    end
  end
end
