# frozen_string_literal: true

module App
  module Physical
    module Mutations
      # Chassis Class
      class UploadChassis < ::Mutations::BaseMutation
        argument :file, ApolloUploadServer::Upload, required: true

        field :success, Boolean, null: false

        def resolve(file:)
          Excel::Chassis::Import.new(file).call
          { success: true }
        rescue Excel::Chassis::ExcelImportError => e
          Rails.logger.error "GRAPHQL ERROR:"
  Rails.logger.error e.class.name
  Rails.logger.error e.message
  Rails.logger.error e.full_message

          err = GraphQL::ExecutionError.new("Erreur lors de l'import")
          err.extensions = {
            code: 'IMPORT_ERROR',
            details: JSON.parse(e.errors.to_json)
          }
          raise err
        end
      end
    end
  end
end
