# frozen_string_literal: true

module App
  module Physical
    module Mutations
      # ComponentType
      class ComponentTypeMutation < ::Mutations::BaseMutation
        input_object_class ::App::Physical::Arguments::ComponentType

        type ::App::Physical::Types::ComponentType

        def resolve(**args)
          baseResolver(::Physical::ComponentType, args)
        end
      end
    end
  end
end
