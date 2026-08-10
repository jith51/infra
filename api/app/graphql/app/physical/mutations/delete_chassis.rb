# frozen_string_literal: true

module App
  module Physical
    module Mutations
      # Suppression d'un Chassis
      class DeleteChassis < ::Mutations::BaseMutation
        argument :id, ID, required: true

        field :deleted_id, ID, null: false

        def resolve(id:)
          { deleted_id: ::Physical::Chassis.find(id).destroy ? id : nil }
        end
      end
    end
  end
end
