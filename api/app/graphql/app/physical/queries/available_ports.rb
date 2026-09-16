# frozen_string_literal: true

module App
  module Physical
    module Queries
      # On ne récupére que les ports sans connections
      class AvailablePorts < ::Queries::BaseQuery
        # Si on donne un chassis id les ports déjàs connectéss sur ce chassis sont ramenès
        argument :chassis_name_or_id, String, required: false

        type [::App::Physical::Types::AvailablePort], null: false

        def resolve(chassis_name_or_id: nil)
          chassis_id =
            ::Physical::Chassis
            .includes(:chassis_class, :components, :ports, :tags)
            .find_by('id::text = :value OR name = :value', value: chassis_name_or_id)&.id

          chassis_port_ids = ::Physical::Port.where(chassis_id: chassis_id).select(:id)

          scope =
            ::Physical::Port
            .joins(:chassis)
            .left_outer_joins(:connection)
            .where(connection: { local_port_id: nil })
            .or(
              ::Physical::Port
                .joins(:chassis)
                .left_outer_joins(:connection)
                .where(connection: { distant_port_id: chassis_port_ids })
            )
            .where.not(id: chassis_port_ids)
            .distinct
          prepare_reponse(scope)
        end

        private

        def prepare_reponse(ports)
          ports.map do |p|
            {
              id: p.id,
              name: "#{p.chassis.name} / #{p.name}"
            }
          end
        end
      end
    end
  end
end
