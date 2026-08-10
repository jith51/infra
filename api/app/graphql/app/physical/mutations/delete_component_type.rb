# frozen_string_literal: true

module App
  module Physical
    module Mutations
      # Suppression d'un Component Type
      class DeleteComponentType < ::Mutations::BaseMutation
        graphql_name 'DeleteComponentType'

        argument :id, ID, required: true

        field :deleted_id, ID, null: false

        def resolve(id:)
          { deleted_id: ::Physical::ComponentType.find(id).destroy ? id : nil }
        end
      end
    end
  end
end
