# frozen_string_literal: true

module App
  module Physical
    module Mutations
      # LinkType
      class LinkTypeMutation < ::Mutations::BaseMutation
        input_object_class ::App::Physical::Arguments::LinkType

        type ::App::Physical::Types::LinkType

        def resolve(**args)
          baseResolver(::Physical::LinkType, args)
        end
      end
    end
  end
end
