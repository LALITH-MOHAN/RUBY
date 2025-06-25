class Users::RegistrationsController < Devise::RegistrationsController
    respond_to :json
  
    def create
      existing_user = User.find_by(email: sign_up_params[:email])
      if existing_user
        render json: { error: 'Email already taken' }, status: :unprocessable_entity
        return
      end
  
      build_resource(sign_up_params)
  
      if resource.save
        token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first
        render json: {
          message: 'Registered successfully',
          user: resource,
          token: token
        }, status: :ok
      else
        render json: {
          errors: resource.errors.full_messages
        }, status: :unprocessable_entity
      end
    end
  end
  