# frozen_string_literal: true

module App
  module Physical
    module Mutations
      # Chassis
      class Chassis < ::Mutations::BaseMutation
        input_object_class ::App::Physical::Arguments::Chassis

        type ::App::Physical::Types::Chassis

        def resolve(**args)
          # On renseigne le type de la class
          # args[:chassis_class_type] = Physical::ChassisClass.find(args[:chassis_class_id]).type || 'Physical::ChassisClass'
          # On modifie l'argument ports en port_attibutes
          baseResolver(::Physical::Chassis, args)
        end
      end
    end
  end
end
