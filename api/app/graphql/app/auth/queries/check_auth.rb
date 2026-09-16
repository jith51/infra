# frozen_string_literal: true

module App
  module Auth
    module Queries
      # Check si l'utilisteur est connecté et refresh le token jwt
      class CheckAuth < ::Queries::BaseQuery
        include UserSession

        type ::App::Auth::Types::Auth, null: false

        def resolve
          token = context[:current_token]
          puts 'CHECK AUTHHHHHHHHHHHH'
          {
            user: {
              id: context[:current_user]
            },
            token: refresh_session(token)
          }
        end
      end
    end
  end
end
