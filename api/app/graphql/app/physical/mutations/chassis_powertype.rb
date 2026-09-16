# frozen_string_literal: true

module App
  module Physical
    module Mutations
      # Chassis
      class ChassisPowertype < ::Mutations::BaseMutation
        input_object_class ::App::Physical::Arguments::ChassisPowertype

        type ::App::Physical::Types::ChassisPowertype, null: false

        def resolve(**args)
          # On construie le json à partir du tableau des custom_attributs
          args[:custom_attributes_definition] = args[:custom_attributes_definition].to_h do |definition|
            [definition[:name], definition.to_h.except(:name)]
          end
          baseResolver(::Physical::ChassisPowertype, args)
        end
      end
    end
  end
end
