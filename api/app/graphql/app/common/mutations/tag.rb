# frozen_string_literal: true

module App
  module Common
    module Mutations
      # Tag
      class Tag < ::Mutations::BaseMutation
        input_object_class ::App::Common::Arguments::Tag

        type ::App::Common::Types::Tag

        def resolve(**args)
          baseResolver(::Tag, args)
        end
      end
    end
  end
end
