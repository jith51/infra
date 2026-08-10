# frozen_string_literal: true

module App
  module Physical
    module Mutations
      # Suppression d'un chassis class
      class DeleteChassisClass < ::Mutations::BaseMutation
        argument :id, ID, required: true

        field :deleted_id, ID, null: false

        def resolve(id:)
          object = ::Physical::ChassisClass.find(id)
          {
            deleted_id: object.destroy ? id : nil
          }
        end
      end
    end
  end
end
