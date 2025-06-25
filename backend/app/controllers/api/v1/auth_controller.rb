class Api::V1::AuthController < ApplicationController
    def register
      user = User.new(user_params)
      if user.save
        render json: { message: 'User created' }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def login
        puts "LOGIN PARAMS: #{params.inspect}" 
      
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          token = encode_token({ user_id: user.id })
          render json: { token: token }, status: :ok
        else
          render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
      end      
  
    private
  
    def user_params
      params.permit(:name, :email, :password)
    end
  
    def encode_token(payload)
        JWT.encode(payload, Rails.application.credentials.secret_key_base)
    end
  end
  