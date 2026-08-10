# frozen_string_literal: true

module App
  module Physical
    module Types
      module Interfaces
        # ChassisClass Interface
        module ChassisClassInterface
          include ::Types::BaseInterface

          orphan_types(::App::Physical::Types::ChassisClassFilterTable)

          field :id, ID, null: false
          field :name, String, null: false

          definition_methods do
            def resolve_type(object, _context)
              object[:number_of_chassis].blank? ? ::App::Physical::Types::ChassisClass : ::App::Physical::Types::ChassisClassFilterTable
            end
          end
        end
      end
    end
  end
end
