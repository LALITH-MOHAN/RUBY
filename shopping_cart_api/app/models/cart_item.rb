class CartItem < ApplicationRecord
  before_create :set_added_at
    belongs_to :user
    belongs_to :product
  
    validates :quantity, numericality: { only_integer: true, greater_than: 0 }
    validates :product_id, uniqueness: { scope: :user_id }
    private
  
    def set_added_at
      self.added_at ||= Time.current
    end
  end