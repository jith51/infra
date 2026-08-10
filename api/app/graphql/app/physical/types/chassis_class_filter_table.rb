# frozen_string_literal: true

module App
  module Physical
    module Types
      # ChassisClassFilterTableType
      class ChassisClassFilterTable < ::Types::BaseObject
        graphql_name 'ChassisClassFilterTableType'

        implements ::App::Physical::Types::Interfaces::ChassisClassInterface

        field :number_of_chassis, Int, null: false
      end
    end
  end
end
