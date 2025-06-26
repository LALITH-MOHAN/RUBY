# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  respond_to :json

  # Skip CSRF for API
  skip_before_action :verify_authenticity_token

  # Skip JWT auth for logout
  skip_before_action :authenticate_user_from_jwt_cookie!, only: [:destroy]

  private

  def respond_with(resource, _opts = {})
    token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first
    cookies.signed[:jwt] = {
      value: token,
      httponly: true,
      same_site: :lax,
      secure: Rails.env.production?
    }

    render json: {
      message: 'Login successful.',
      user: resource.slice(:id, :name, :email, :role)
    }, status: :ok
  end

  def respond_to_on_destroy
    if cookies.signed[:jwt].present?
      cookies.delete(:jwt)
      render json: { message: 'Logout successful.' }, status: :ok
    else
      render json: { message: 'No active session.' }, status: :unauthorized
    end
  end
end
