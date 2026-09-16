# frozen_string_literal: true

module App
  module Auth
    module Mutations
      # Vérifiecation du tocken CAS
      class UserCasLogin < ::Mutations::BaseMutation
        include UserSession

        argument :ticket, String, required: true
        argument :service, String, required: true

        field :token, String, null: true
        field :user, String, null: true

        def resolve(ticket:, service:)
          reponse_cas = cas_verify(ticket, service)
          puts 'hjhjkhlkhlkhkhh'
          puts service
          puts ticket
          puts reponse_cas
          puts 'hjhjkhlkhlkhkhh'
          if reponse_cas.first == 'yes'
            user_cas = reponse_cas.last
            token = create_session(user_cas)
          else
            token = ''
            raise Errors::AuthenticationError, 'permission denied'
          end
          {
            token: token,
            user: user_cas
          }
        end

        private

        def cas_verify(ticket, service)
          cas_url = Rails.application.config_for(:cas)[:url]
          url = "#{cas_url}/validate?service=#{service}&ticket=#{ticket}"
          reponse = Faraday.get(url)
          reponse.body.split("\n")
        end
      end
    end
  end
end
