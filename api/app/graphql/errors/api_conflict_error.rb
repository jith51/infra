# frozen_string_literal: true

module Errors
  # Erreur active record : ressource déjà existante
  class ApiConflictError < ApiExecutionError
    def initialize(message = 'Resource already exists')
      super(
        message,
        code: ApiErrorCodes::CONFLICT
      )
    end
  end
end
