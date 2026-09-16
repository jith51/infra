# frozen_string_literal: true

module Errors
  # Erreur d'authentification
  class AuthenticationError < GraphQL::ExecutionError
    def to_h
      super.merge(extensions: { code: 'AUTHENTICATION_ERROR' })
    end
  end
end
