class ProductsService
    PER_PAGE = 9
  
    def initialize(user = nil)
      @current_user = user
    end
  
    def index(page)
      page = (page || 1).to_i
      products = Product.offset((page - 1) * PER_PAGE).limit(PER_PAGE)
      total = Product.count
  
      {
        products: products,
        currentPage: page,
        totalPages: (total / PER_PAGE.to_f).ceil,
        total: total
      }
    end
  
    def show(id)
      Product.find_by(id: id)
    end
  
    def create(product_params)
      product = Product.new(product_params)
      if product.save
        { success: true, product: product }
      else
        { success: false, errors: product.errors }
      end
    end
  
    def update(id, product_params)
      product = Product.find_by(id: id)
      return { success: false, error: 'Product not found' } unless product
  
      if product.update(product_params)
        { success: true, product: product }
      else
        { success: false, errors: product.errors }
      end
    end
  
    def destroy(id)
      product = Product.find_by(id: id)
      return { success: false, error: 'Product not found' } unless product
  
      product.destroy
      { success: true }
    end
  
    def categories
      Product.distinct.pluck(:category).compact
    end
  
    def by_category(category, page)
      page = (page || 1).to_i
      category = category.to_s.downcase
  
      products = Product
        .where('LOWER(category) = ?', category)
        .offset((page - 1) * PER_PAGE)
        .limit(PER_PAGE)
  
      total = Product.where('LOWER(category) = ?', category).count
  
      {
        products: products,
        currentPage: page,
        totalPages: (total / PER_PAGE.to_f).ceil,
        total: total
      }
    end
  end