# frozen_string_literal: true

# Modul de gestion des sessions utilisteurs
module UserSession
  SECRET_KEY = Rails.application.secret_key_base
  SESSION_TTL = 20.minutes

  def create_session(user_id)
    session_id = SecureRandom.uuid

    redis_key = redis_session_key(session_id)

    REDIS.hset(redis_key, 'user_id', user_id)
    REDIS.expire(redis_key, SESSION_TTL.to_i)

    jwt_encode(
      user_id: user_id,
      session_id: session_id
    )
  end

  def authenticate_session(token)
    payload = decode_token(token)
    return nil unless payload

    session_id = payload['session_id']
    return nil unless session_id

    redis_key = redis_session_key(session_id)

    return nil unless REDIS.exists?(redis_key)
    return nil unless REDIS.ttl(redis_key).positive?

    # Session glissante
    REDIS.expire(redis_key, SESSION_TTL.to_i)

    payload
  end

  def refresh_session(token)
    payload = authenticate_session(token)
    return nil unless payload

    jwt_encode(
      user_id: payload['user_id'],
      session_id: payload['session_id']
    )
  end

  def delete_session(token)
    payload = decode_token(token)
    return unless payload

    session_id = payload['session_id']
    return unless session_id

    REDIS.del(redis_session_key(session_id))
  end

  private

  def redis_session_key(session_id)
    "session:#{session_id}"
  end

  def jwt_encode(payload)
    payload = payload.merge(
      exp: SESSION_TTL.from_now.to_i
    )

    JWT.encode(
      payload,
      SECRET_KEY,
      'HS256'
    )
  end

  def decode_token(token)
    JWT.decode(
      token,
      SECRET_KEY,
      true,
      algorithm: 'HS256'
    ).first
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end
end
