# frozen_string_literal: true

module App
  module Common
    module Types
      # ChassisClassType
      class TagType < ::Types::BaseObject
        graphql_name 'TagType'
        implements ::App::Common::Types::Interfaces::TagInterface
      end
    end
  end
end
