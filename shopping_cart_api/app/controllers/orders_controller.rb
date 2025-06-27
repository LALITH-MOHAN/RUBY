class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    orders = current_user.orders.includes(:order_items) .order(created_at: :desc)
    render json: {
      orders: orders.map { |order| format_order(order) }
    }
  end

  def create
    cart_items = current_user.cart_items.includes(:product)
    return render json: { error: 'Cart is empty' }, status: :bad_request if cart_items.empty?

    total = cart_items.sum { |item| item.product.price * item.quantity }

    ActiveRecord::Base.transaction do
      order = current_user.orders.create!(
        total: total,
        status: 'pending'
      )

      cart_items.each do |cart_item|
        product = cart_item.product
        if product.stock < cart_item.quantity
          raise ActiveRecord::Rollback, "Not enough stock for #{product.title}"
        end

        order.order_items.create!(
          product_id: product.id,
          title: product.title,
          price: product.price,
          quantity: cart_item.quantity,
          thumbnail: product.thumbnail
        )

        product.update!(stock: product.stock - cart_item.quantity)
      end

      current_user.cart_items.destroy_all

      render json: [format_order(order)], status: :created
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue => e
    render json: { error: e.message }, status: :bad_request
  end

  private

  def format_order(order)
    {
      id: order.id,
      userId: order.user_id,
      total: order.total.to_f,
      status: order.status,
      date: order.created_at.iso8601,
      items: order.order_items.map do |item|
        {
          id: item.product_id,
          title: item.title,
          price: item.price.to_f,
          quantity: item.quantity,
          thumbnail: item.thumbnail
        }
      end
    }
  end
end

