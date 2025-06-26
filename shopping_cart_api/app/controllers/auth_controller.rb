class AuthController < ApplicationController
    before_action :authenticate_user!
  
    def show
      render json: {
        user: current_user.slice(:id, :name, :email, :role)
      }, status: :ok
    rescue => e
      render json: { error: 'Not authenticated' }, status: :unauthorized
    end
  end