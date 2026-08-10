# frozen_string_literal: true

module App
  module Physical
    module Mutations
      # Suppression d'un Port Type
      class DeletePortType < ::Mutations::BaseMutation
        graphql_name 'DeletePortType'

        argument :id, ID, required: true

        field :deleted_id, ID, null: false

        def resolve(id:)
          { deleted_id: ::Physical::PortType.find(id).destroy ? id : nil }
        end
      end
    end
  end
end
