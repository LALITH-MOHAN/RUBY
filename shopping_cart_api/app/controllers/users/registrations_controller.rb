class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  
  # Remove the skip_before_action line completely
  # verify_authenticity_token isn't loaded in API mode so we don't need to skip it

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first
      cookies.signed[:jwt] = {
        value: token,
        httponly: true,
        same_site: :lax,
        secure: Rails.env.production?
      }

      render json: {
        message: 'Registration successful.',
        user: resource.slice(:id, :name, :email)
      }, status: :created
    else
      render json: {
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
