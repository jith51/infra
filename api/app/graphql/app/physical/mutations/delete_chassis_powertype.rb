# frozen_string_literal: true

module App
  module Physical
    module Mutations
      # Suppression d'un ChassisPowertype
      class DeleteChassisPowertype < ::Mutations::BaseMutation
        argument :id, ID, required: true

        field :deleted_id, ID, null: false

        def resolve(id:)
          { deleted_id: ::Physical::ChassisPowertype.find(id).destroy ? id : nil }
        end
      end
    end
  end
end
