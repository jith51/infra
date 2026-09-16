# frozen_string_literal: true

module Errors
  # Classe Mére
  class ApiExecutionError < GraphQL::ExecutionError
    def initialize(message, code: ApiErrorCodes::INTERNAL, field_errors: nil)
      extensions = {
        code: code
      }

      extensions[:field_errors] = field_errors if field_errors.present?

      super(message, extensions: extensions)
    end
  end
end
