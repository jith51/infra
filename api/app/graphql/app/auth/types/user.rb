# frozen_string_literal: true

module App
  module Auth
    module Types
      # Retour de l'authentification
      class User < ::Types::BaseObject
        graphql_name 'UserType'

        field :id, String, null: false
      end
    end
  end
end
