module AuthGql
    module Mutations
        class UserLogout < ::Mutations::BaseMutation
            include UserSession

            argument :fake, String, required: false

            field :fake, String, null: true

            def resolve(**args)
                # delete_session : lib UserSession module
                delete_session(context[:current_token]) # gérer l'erreur unauthorized --> si pas de token
                return { fake: '' }
            end
        end
    end
end