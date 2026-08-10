# frozen_string_literal: true

module App
  module Physical
    module Mutations
      # PortType
      class PortTypeMutation < ::Mutations::BaseMutation
        input_object_class ::App::Physical::Arguments::PortType

        type ::App::Physical::Types::PortType

        def resolve(**args)
          baseResolver(::Physical::PortType, args)
        end
      end
    end
  end
end
