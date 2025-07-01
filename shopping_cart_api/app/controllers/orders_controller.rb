class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :initialize_orders_service

  def index
    orders = @orders_service.index
    render json: { orders: orders }
  end

  def create
    result = @orders_service.create
    if result[:success]
      render json: [result[:order]], status: result[:status]
    else
      render json: { error: result[:error] }, status: result[:status]
    end
  end

  private

  def initialize_orders_service
    @orders_service = OrdersService.new(current_user)
  end
end