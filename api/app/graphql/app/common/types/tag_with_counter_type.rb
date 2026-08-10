# frozen_string_literal: true

module App
  module Common
    module Types
      # ChassisClassType
      class TagWithCounterType < ::Types::BaseObject
        graphql_name 'TagWithCounterType'

        implements ::App::Common::Types::Interfaces::TagInterface

        field :number_of_things, Int, null: false
      end
    end
  end
end
