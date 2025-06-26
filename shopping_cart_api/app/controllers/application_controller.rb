class ApplicationController < ActionController::API
  # Enable cookies and CSRF protection
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  # Handle CSRF for APIs with cookies
  protect_from_forgery with: :null_session

  # Authenticate user from JWT in cookie for all requests
  before_action :authenticate_user_from_jwt_cookie!

  private

  def authenticate_user_from_jwt_cookie!
    token = cookies.signed[:jwt]
    return unless token

    begin
      # Decode the JWT
      payload = Warden::JWTAuth::TokenDecoder.new.call(token)

      # Find user using subject (sub) from token
      user = User.find_by(id: payload['sub'])

      # Authenticate user without storing session
      sign_in(user, store: false) if user
    rescue JWT::DecodeError, JWT::ExpiredSignature
      head :unauthorized
    end
  end
end
