# frozen_string_literal: true

module App
  module Physical
    module Queries
      # Powertypes des chassis
      class ChassisPowertypes < ::Queries::BaseQuery
        argument :with_chassis_class_counter, Boolean, required: false, default_value: false

        type [::App::Physical::Types::ChassisPowertype], null: false

        def resolve(with_chassis_class_counter:)
          scope = ::Physical::ChassisPowertype.all

          if with_chassis_class_counter
            scope = scope.left_outer_joins(:chassis_classes).select(
              'powertypes.*',
              'COUNT(physical_chassis_classes.id) AS chassis_classes_number'
            ).group('powertypes.id')
          end

          scope
        end
      end
    end
  end
end
