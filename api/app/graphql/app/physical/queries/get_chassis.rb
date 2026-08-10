# frozen_string_literal: true

module App
  module Physical
    module Queries
      # GetChassis
      class GetChassis < ::Queries::BaseQuery
        type ::App::Physical::Types::Chassis, null: true

        argument :name_or_id, String, required: false

        def resolve(name_or_id: nil)
          return nil if name_or_id.blank?

          # ::Physical::Chassis.includes(
          #   :chassis_class, :components, ports: [:chassis, { connection: [:distant] }]
          # ).find_by!(name: name)
          ::Physical::Chassis
            .includes(:chassis_class, :components, :ports, :tags)
            .find_by('id::text = :value OR name = :value', value: name_or_id)
        end
      end
    end
  end
end
