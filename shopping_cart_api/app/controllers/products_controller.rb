class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :categories, :by_category]
  before_action :authorize_admin!, only: [:create, :update, :destroy]
  before_action :set_product, only: [:show, :update, :destroy]


  PER_PAGE = 9

  # GET /products?page=1
  def index
    page = (params[:page] || 1).to_i
    products = Product.offset((page - 1) * PER_PAGE).limit(PER_PAGE)
    total = Product.count

    render json: {
      products: products,
      currentPage: page,
      totalPages: (total / PER_PAGE.to_f).ceil,
      total: total
    }
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

  # GET /products/categories
  def categories
    categories = Product.distinct.pluck(:category).compact
    render json: categories
  end

  # GET /products/category/:category?page=1
  def by_category
    page = (params[:page] || 1).to_i
    category = params[:category].to_s.downcase

    products = Product
      .where('LOWER(category) = ?', category)
      .offset((page - 1) * PER_PAGE)
      .limit(PER_PAGE)

    total = Product.where('LOWER(category) = ?', category).count

    render json: {
      products: products,
      currentPage: page,
      totalPages: (total / PER_PAGE.to_f).ceil,
      total: total
    }
  end

  private

  def product_params
    params.require(:product).permit(:title, :price, :thumbnail, :stock, :description, :category)
  end

  def set_product
    @product = Product.find_by(id: params[:id])
    return render json: { error: 'Product not found' }, status: :not_found unless @product
  end

  def authorize_admin!
    unless current_user&.role == 'admin'
      render json: { error: 'Access denied. Admins only.' }, status: :forbidden
    end
  end
end
