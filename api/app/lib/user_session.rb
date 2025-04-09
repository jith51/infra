module UserSession

    SECRET_KEY = Rails.application.secret_key_base

    def create_session(user_id)
        # Création du jwt (qui sert de session)
        token = jwt_encode(user_id: user_id)
        # Enregistrement de la session dans Redis avec les info du user
        $redis.hset(token, 'user_id', user_id)
        $redis.expire(token, 40.minutes.to_i)

        return token
    end

    def delete_session(token)
        $redis.del(token) # gérer l'erreur unauthorized --> si pas de token
    end

    def authenticate_session(token)
        authenticated_token = nil
        if AuthTokenValid?(token) && $redis.ttl(token) > 0
            authenticated_token = token
            $redis.expire(token, 20.minutes.to_i) # set TTL as constant
        end
        return authenticated_token
    end

    def jwt_encode(payload, exp = 20.minutes.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, SECRET_KEY)
    end

    def AuthTokenValid?(token)
        JWT.decode(token, SECRET_KEY) rescue false
    end

end