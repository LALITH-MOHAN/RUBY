class ApplicationController < ActionController::API
    def authenticate_user!
      header = request.headers['Authorization']
      token = header.split(' ').last if header
      decoded = decode_token(token)
  
      if decoded
        @current_user = User.find_by(id: decoded[:user_id])
      else
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end
  
    def decode_token(token)
        begin
          decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
          HashWithIndifferentAccess.new(decoded)
        rescue
          nil
        end
      end
      
    end      