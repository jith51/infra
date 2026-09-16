# frozen_string_literal: true

module App
  module Physical
    module Mutations
      # Chassis
      class Chassis < ::Mutations::BaseMutation
        include Concern::NestedAttributes

        input_object_class ::App::Physical::Arguments::Chassis

        type ::App::Physical::Types::Chassis

        def resolve(**args)
          # On construie gere les connections
          args[:ports_attributes] = prepare_connection_attributes(args[:ports_attributes])
          if args[:id].present?
            args = prepare_nested_attributes(::Physical::Chassis.find(args[:id]), args, :components_attributes, :ports_attributes)
          end
          baseResolver(::Physical::Chassis, args)
        end

        def prepare_connection_attributes(ports_attribute)
          ports_attribute.map do |port|
            connection = port[:connection_attributes]

            if connection.blank? || (connection[:id].blank? && connection[:distant_port_id].blank?)
              # Suppression des connection_attributs si inexistant ou qu'il n'a ni id ni distand_id (pas en base)
              port.delete(:connection_attributes)
            elsif connection[:distant_port_id].blank?
              # On marque le connection_attributes à destroy si existant, id present et distant_id non
              connection[:_destroy] = true
              connection[:distant_port_id] = 'fake'
            end

            port
          end
        end
      end
    end
  end
end
