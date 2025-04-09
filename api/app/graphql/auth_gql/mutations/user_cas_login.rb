module AuthGql
    module Mutations
        class UserCasLogin < ::Mutations::BaseMutation
            include UserSession

            argument :ticket, String, required: true
            argument :service, String, required: true

            field :token, String, null: true
            field :user, String, null: true

            def resolve(**args)
                reponse_cas = casVerify(args[:ticket], args[:service])

                if (reponse_cas.first == 'yes')
                    user_cas = reponse_cas.last
                    token = create_session(user_cas)
                else
                    token = ""
                    raise Errors::AuthenticationError, 'permission denied'
                end
                { 
                    token: token,
                    user: user_cas
                }

            end  
            
        private 
            def casVerify(ticket, service)
                url = "https://cas.chu-reims.fr/validate?service=#{service}&ticket=#{ticket}"
                reponse = Faraday.get(url)
                return reponse.body.split("\n")
            end
        end
    end
end