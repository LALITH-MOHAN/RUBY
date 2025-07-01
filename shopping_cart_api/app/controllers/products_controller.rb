class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :categories, :by_category]
  before_action :authorize_admin!, only: [:create, :update, :destroy]
  before_action :initialize_products_service

  # GET /products?page=1
  def index
    result = @products_service.index(params[:page])
    render json: result
  end

  # GET /products/:id
  def show
    product = @products_service.show(params[:id])
    if product
      render json: product
    else
      render json: { error: 'Product not found' }, status: :not_found
    end
  end

  # POST /products (admin only)
  def create
    result = @products_service.create(product_params)
    if result[:success]
      render json: result[:product], status: :created
    else
      render json: result[:errors], status: :unprocessable_entity
    end
  end

  # PUT /products/:id (admin only)
  def update
    result = @products_service.update(params[:id], product_params)
    if result[:success]
      render json: result[:product]
    else
      render json: result.slice(:error, :errors), status: result[:error] ? :not_found : :unprocessable_entity
    end
  end

  # DELETE /products/:id (admin only)
  def destroy
    result = @products_service.destroy(params[:id])
    if result[:success]
      head :no_content
    else
      render json: result[:error], status: :not_found
    end
  end

  # GET /products/categories
  def categories
    categories = @products_service.categories
    render json: categories
  end

  # GET /products/category/:category?page=1
  def by_category
    result = @products_service.by_category(params[:category], params[:page])
    render json: result
  end

  private

  def initialize_products_service
    @products_service = ProductsService.new(current_user)
  end

  def product_params
    params.require(:product).permit(:title, :price, :thumbnail, :stock, :description, :category)
  end

  def authorize_admin!
    unless current_user&.role == 'admin'
      render json: { error: 'Access denied. Admins only.' }, status: :forbidden
    end
  end
end