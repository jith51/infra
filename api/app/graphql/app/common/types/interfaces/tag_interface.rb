# frozen_string_literal: true

module App
  module Common
    module Types
      module Interfaces
        # Tag Interface
        module TagInterface
          include ::Types::BaseInterface

          orphan_types(::App::Common::Types::TagType, ::App::Common::Types::TagWithCounterType)

          field :id, ID, null: false
          field :name, String, null: false

          definition_methods do
            def resolve_type(object, _context)
              object[:number_of_things].blank? ? ::App::Common::Types::TagType : ::App::Common::Types::TagWithCounterType
            end
          end
        end
      end
    end
  end
end
