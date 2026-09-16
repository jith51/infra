# frozen_string_literal: true

module App
  module Auth
    module Types
      # Liste des mutations
      class MutationType < ::Types::BaseObject
        graphql_name 'AuthMutationType'
        field :user_cas_login, mutation: ::App::Auth::Mutations::UserCasLogin
        field :user_logout, mutation: ::App::Auth::Mutations::UserLogout
      end
    end
  end
end
