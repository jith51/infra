# frozen_string_literal: true

module Errors
  # Action interdite
  class ApiForbiddenError < ApiExecutionError
    def initialize(message = 'You are not allowed to perform this action')
      super(
        message,
        code: ApiErrorCodes::FORBIDDEN
      )
    end
  end
end
