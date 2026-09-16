# frozen_string_literal: true

module App
  module Physical
    module Mutations
      # Suppression d'un Link Type
      class DeleteLinkType < ::Mutations::BaseMutation
        graphql_name 'DeleteLinkType'

        argument :id, ID, required: true

        field :deleted_id, ID, null: false

        def resolve(id:)
          { deleted_id: ::Physical::LinkType.find(id).destroy ? id : nil }
        end
      end
    end
  end
end
