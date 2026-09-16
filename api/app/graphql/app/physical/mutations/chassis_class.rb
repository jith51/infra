# frozen_string_literal: true

module App
  module Physical
    module Mutations
      # Chassis Class
      class ChassisClass < ::Mutations::BaseMutation
        include Concern::NestedAttributes

        input_object_class ::App::Physical::Arguments::ChassisClass

        type ::App::Physical::Types::ChassisClass

        def resolve(**args)
          object = args[:id].blank? ? ::Physical::ChassisClass.new : ::Physical::ChassisClass.find(args[:id])

          # On s'occupe des images
          prepare_images(object, args)

          # On construie le json à partir du tableau des custom_attributs
          args[:custom_attributes_definition] = args[:custom_attributes_definition].to_h do |custom_attibute|
            [custom_attibute[:name], custom_attibute.to_h.except(:name)]
          end

          # On construie le component_attributes et on supprime le components --> accpt_nested_attributes_for
          args = prepare_nested_attributes(object, args, :component_slots_attributes, :port_slots_attributes)

          baseResolver(::Physical::ChassisClass, args)
        end

        private

        def prepare_images(object, args)
          # On purge le images si non renseignées
          object.front_image.purge if args[:front_image].blank?
          object.back_image.purge if args[:back_image].blank?
          # Suppression des args front_image et back_image si egal a la version path
          # Dna sce cas nous sommes en update et aucune modification n'a été faite
          args.delete(:front_image) if args[:front_image] == object.front_image_url_path
          args.delete(:back_image) if args[:back_image] == object.back_image_url_path
        end
      end
    end
  end
end
