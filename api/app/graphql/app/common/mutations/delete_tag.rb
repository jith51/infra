# frozen_string_literal: true

module App
  module Common
    module Mutations
      # Suppression d'un Tag
      class DeleteTag < ::Mutations::BaseMutation
        graphql_name 'DeleteTag'

        argument :id, ID, required: true

        field :deleted_id, ID, null: false

        def resolve(id:)
          { deleted_id: ::Tag.find(id).destroy ? id : nil }
        end
      end
    end
  end
end
