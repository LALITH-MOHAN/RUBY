class ApplicationController < ActionController::API
  include ActionController::Cookies
  
  # Remove the CSRF protection line completely
  # Don't use skip_before_action as verify_authenticity_token isn't loaded in API mode

  before_action :authenticate_user_from_jwt_cookie!

  private

  def authenticate_user_from_jwt_cookie!
    token = cookies.signed[:jwt]
    return unless token

    begin
      payload = Warden::JWTAuth::TokenDecoder.new.call(token)
      user = User.find_by(id: payload['sub'])
      sign_in(user, store: false) if user
    rescue JWT::DecodeError, JWT::ExpiredSignature
      # Don't return unauthorized here to allow public routes
      nil
    end
  end
end