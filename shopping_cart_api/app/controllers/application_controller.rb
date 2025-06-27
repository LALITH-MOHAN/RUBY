class ApplicationController < ActionController::API
  include ActionController::Cookies

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
      nil
    end
  end
end