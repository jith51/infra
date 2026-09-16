# frozen_string_literal: true

module App
  module Auth
    module Mutations
      # LogOut : suppression de la session
      class UserLogout < ::Mutations::BaseMutation
        include UserSession

        argument :fake, String, required: false

        field :fake, String, null: true

        def resolve(*)
          # delete_session : lib UserSession module
          delete_session(context[:current_token]) # gérer l'erreur unauthorized --> si pas de token
          { fake: '' }
        end
      end
    end
  end
end
