class Users::RegistrationsController < Devise::RegistrationsController
  
  respond_to :json
  
  
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
