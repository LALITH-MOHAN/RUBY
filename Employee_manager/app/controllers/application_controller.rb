class ApplicationController < ActionController::API
  include ActionController::Cookies
  respond_to :json

  before_action :authenticate_user_from_jwt_cookie!

  private

  def authenticate_user_from_jwt_cookie!
    token = cookies.signed[:jwt]
    return unless token

    begin
      payload = Warden::JWTAuth::TokenDecoder.new.call(token)
      user = User.find(payload['sub'])
      sign_in(user, store: false)
    rescue JWT::ExpiredSignature, JWT::DecodeError
      head :unauthorized
    end
  end
end
