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
          args[:custom_attributes] = args[:custom_attributes].to_h do |custom_attibute|
            [custom_attibute[:name], custom_attibute.to_h.except(:name)]
          end
          baseResolver(::Physical::ChassisPowertype, args)
        end
      end
    end
  end
end
