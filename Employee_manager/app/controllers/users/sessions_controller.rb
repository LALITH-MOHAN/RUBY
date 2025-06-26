class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first

    # Set JWT in HttpOnly cookie
    cookies.signed[:jwt] = {
      value: token,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :lax,
      expires: 1.day.from_now
    }

    render json: {
      message: 'Logged in successfully',
      user: resource.as_json(only: [:id, :email])
    }, status: :ok
  end

  def respond_to_on_destroy
    # Remove cookie on logout
    cookies.delete(:jwt)

    render json: { message: 'Logged out successfully' }, status: :ok
  end
end
