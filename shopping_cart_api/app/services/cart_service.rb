class OrdersService
    def initialize(user)
      @current_user = user
    end
  
    def index
      orders = @current_user.orders.includes(:order_items).order(created_at: :desc)
      orders.map { |order| format_order(order) }
    end
  
    def create
      cart_items = @current_user.cart_items.includes(:product)
      return { success: false, error: 'Cart is empty', status: :bad_request } if cart_items.empty?
  
      total = calculate_total(cart_items)
  
      begin
        ActiveRecord::Base.transaction do
          order = create_order(total)
          process_order_items(order, cart_items)
          clear_cart
          
          { success: true, order: format_order(order), status: :created }
        end
      rescue ActiveRecord::RecordInvalid => e
        { success: false, error: e.message, status: :unprocessable_entity }
      rescue => e
        { success: false, error: e.message, status: :bad_request }
      end
    end
  
    private
  
    def calculate_total(cart_items)
      cart_items.sum { |item| item.product.price * item.quantity }
    end
  
    def create_order(total)
      @current_user.orders.create!(
        total: total,
        status: 'pending'
      )
    end
  
    def process_order_items(order, cart_items)
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
    end
  
    def clear_cart
      @current_user.cart_items.destroy_all
    end
  
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