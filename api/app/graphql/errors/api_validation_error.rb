# frozen_string_literal: true

module Errors
  # Erreur spécifique Active Record
  # Exemple :
  #   {
  #   "errors": [
  #     {
  #       "message": "Validation failed",
  #       "extensions": {
  #         "code": "VALIDATION_ERROR",
  #         "field_errors": {
  #           "name": [
  #             "can't be blank"
  #           ]
  #         }
  #       }
  #     }
  #   ]
  # }
  class ApiValidationError < ApiExecutionError
    def initialize(error)
      super(
        'Validation failed',
        code: ApiErrorCodes::VALIDATION,
        field_errors: error.record.errors.messages.transform_keys(&:to_s)
      )
    end
  end
end
