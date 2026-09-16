# frozen_string_literal: true

module Errors
  # Acces interdit
  class ApiUnauthorizedError < ApiExecutionError
    def initialize(message = 'Authentication required')
      super(
        message,
        code: ApiErrorCodes::UNAUTHORIZED
      )
    end
  end
end
