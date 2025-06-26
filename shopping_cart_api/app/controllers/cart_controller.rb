class CartController < ApplicationController
    before_action :authenticate_user!
  
    def index
      cart_items = current_user.cart_items.includes(:product)
      render json: cart_items.map { |item| format_cart_item(item) }
    end
  
    def create
      product = Product.find(params[:productId])
      cart_item = current_user.cart_items.find_or_initialize_by(product_id: product.id)
      
      # For new items, set quantity to 1 (or requested amount)
      # For existing items, increment by 1 (or requested amount)
      requested_quantity = (params[:quantity] || 1).to_i
      new_quantity = cart_item.new_record? ? requested_quantity : (cart_item.quantity + requested_quantity)
  
      if new_quantity > product.stock
        return render json: { error: "You can't add more than #{product.stock} items of this product" }, 
                      status: :bad_request
      end
  
      cart_item.quantity = new_quantity
      if cart_item.save
        render json: format_cart_item(cart_item)
      else
        render json: { errors: cart_item.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
  def update
    cart_item = current_user.cart_items.find_by(product_id: params[:id])
    return render json: { error: 'Item not found in cart' }, status: :not_found unless cart_item

    if params[:quantity].to_i < 1
      cart_item.destroy
      return render json: { message: 'Item removed from cart' }
    end

    if params[:quantity].to_i > cart_item.product.stock
      return render json: { error: "You can't add more than #{cart_item.product.stock} items of this product" }, 
                    status: :bad_request
    end

    if cart_item.update(quantity: params[:quantity])
      render json: format_cart_item(cart_item)
    else
      render json: { errors: cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:id]
      # Remove single item
      cart_item = current_user.cart_items.find_by(product_id: params[:id])
      if cart_item&.destroy
        render json: { message: 'Item removed from cart' }
      else
        render json: { error: 'Item not found in cart' }, status: :not_found
      end
    else
      # Clear entire cart
      current_user.cart_items.destroy_all
      render json: { message: 'Cart cleared' }
    end
  end

  private

  def format_cart_item(item)
    {
      id: item.product_id,
      quantity: item.quantity,
      title: item.product.title,
      price: item.product.price,
      thumbnail: item.product.thumbnail,
      stock: item.product.stock
    }
  end
end