class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include UserSession

  def authenticate
    authenticate_token || render_unauthorized
  end

  def current_token
    @token || nil
  end
  
  def current_user
    @current_user ||= $redis.hget(current_token, :user_id) if current_token
  end

  def authenticate_token    
    authenticate_with_http_token do |token, options|
      # authenticate_session : lib UserSession module
      @token = authenticate_session(token)
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render nothing: true, status: :unauthorized, content_type: 'application/json'
  end

end