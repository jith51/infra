# frozen_string_literal: true

module App
  module Common
    module Types
      # ChassisClassType
      class Tag < ::Types::BaseObject
        graphql_name 'TagType'
        field :id, ID, null: false
        field :name, String, null: false
        field :number_of_things, Int, null: true

        def number_of_things
          return nil unless object.respond_to?(:number_of_things)

          object.number_of_things
        end
      end
    end
  end
end
