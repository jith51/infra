# frozen_string_literal: true

module App
  module Physical
    module Queries
      # Classes de chassis
      class ChassisClasses < ::Queries::BaseQuery
        type [::App::Physical::Types::Interfaces::ChassisClassInterface], null: false

        argument :name, String, required: false, default_value: nil
        argument :chassis_powertype_ids, [String], required: false, default_value: []
        argument :fournisseur, String, required: false, default_value: nil
        argument :limit, Integer, required: false, default_value: nil
        argument :page, Integer, required: false, default_value: nil
        argument :for_filter, Boolean, required: false, default_value: false

        def resolve(limit:, page:, name:, fournisseur:, chassis_powertype_ids:, for_filter:)
          if for_filter
            ::Physical::ChassisClass.left_outer_joins(:chassis).select(
              :id,
              :name,
              'COUNT(physical_chassis.id) AS number_of_chassis'
            ).group('physical_chassis_classes.id')
          else
            return ::Physical::ChassisClass.all if limit.blank?

            scope =
              ::Physical::ChassisClass
              .left_outer_joins(:chassis_powertype)
              .includes(:components, :ports)
            scope = scope.where('physical_chassis_classes.name LIKE ?', "%#{name}%") if name.present?
            scope = scope.where('physical_chassis_classes.fournisseur LIKE ?', "%#{fournisseur}%") if fournisseur.present?
            scope = scope.where(chassis_powertype: { id: chassis_powertype_ids }) if chassis_powertype_ids.present?
            scope.limit(limit).offset(page || 0)
          end
        end
      end
    end
  end
end
