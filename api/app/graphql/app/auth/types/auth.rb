# frozen_string_literal: true

module App
  module Auth
    module Types
      # Retour de l'authentification
      class Auth < ::Types::BaseObject
        graphql_name 'AuthType'

        field :user, ::App::Auth::Types::User, null: true
        field :token, String, null: false
      end
    end
  end
end
