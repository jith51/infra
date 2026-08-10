# frozen_string_literal: true

module App
  module Physical
    module Mutations
      # Chassis Class
      class UploadChassisClasses < ::Mutations::BaseMutation
        argument :file, ApolloUploadServer::Upload, required: true

        field :success, Boolean, null: false

        def resolve(file:)
          Excel::ChassisClass::Import.new(file).call
          { success: true }
        rescue Excel::ChassisClass::ExcelImportError => e
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
