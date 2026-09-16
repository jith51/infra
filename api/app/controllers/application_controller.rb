# frozen_string_literal: true

# Controller de base
class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include UserSession

  def authenticate
    authenticate_token || render_unauthorized
  end

  def current_token
    @token
  end

  def current_user
    @current_user
  end

  def authenticate_token
    authenticate_with_http_token do |token, _|
      payload = authenticate_session(token)

      return false unless payload

      @token = token

      @current_user = REDIS.hget(
        redis_session_key(payload['session_id']),
        'user_id'
      )
      true
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'

    render(
      nothing: true,
      status: :unauthorized,
      content_type: 'application/json'
    )
  end
end
