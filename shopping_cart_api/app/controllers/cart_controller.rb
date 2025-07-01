class CartController < ApplicationController
  before_action :authenticate_user!
  before_action :initialize_cart_service

  def index
    cart_items = @cart_service.index
    render json: cart_items
  end

  def create
    result = @cart_service.create(params[:productId], params[:quantity])
    if result[:success]
      render json: result[:cart_item]
    else
      render json: { error: result[:error] }, status: result[:status] || :unprocessable_entity
    end
  end

  def update
    result = @cart_service.update(params[:id], params[:quantity])
    if result[:success]
      render json: result[:cart_item] || { message: result[:message] }
    else
      render json: { error: result[:error] }, status: result[:status] || :unprocessable_entity
    end
  end

  def destroy
    result = @cart_service.destroy(params[:id])
    if result[:success]
      render json: { message: result[:message] }
    else
      render json: { error: result[:error] }, status: result[:status] || :unprocessable_entity
    end
  end

  private

  def initialize_cart_service
    @cart_service = CartService.new(current_user)
  end
end