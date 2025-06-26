class ProductsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user!, except: [:index, :show]
    before_action :authorize_admin!, only: [:create, :update, :destroy]
    before_action :set_product, only: [:show, :update, :destroy]
  
    # GET /products
    def index
      @products = Product.all
      render json: @products
    end
  
    # GET /products/:id
    def show
      render json: @product
    end
  
    # POST /products (admin only)
    def create
      @product = Product.new(product_params)
      if @product.save
        render json: @product, status: :created
      else
        render json: @product.errors, status: :unprocessable_entity
      end
    end
  
    # PUT /products/:id (admin only)
    def update
      if @product.update(product_params)
        render json: @product
      else
        render json: @product.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /products/:id (admin only)
    def destroy
      @product.destroy
      head :no_content
    end
  
    private
  
    def set_product
      @product = Product.find(params[:id])
    end
  
    def product_params
      params.require(:product).permit(:title, :price, :thumbnail, :stock, :description, :category)
    end
  
    def authorize_admin!
      unless current_user&.role == "admin"
        render json: { error: "Access denied. Admins only." }, status: :forbidden
      end
    end
  end
  