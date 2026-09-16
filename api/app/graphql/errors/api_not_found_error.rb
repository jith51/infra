# frozen_string_literal: true

module Errors
  # Erreur spécifique Active Record: not found
  class ApiNotFoundError < ApiExecutionError
    def initialize(message = 'Resource not found')
      super(
        message,
        code: ApiErrorCodes::NOT_FOUND
      )
    end
  end
end
