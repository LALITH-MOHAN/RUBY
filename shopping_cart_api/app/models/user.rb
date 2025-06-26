class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  validates :name, presence: true, length: { maximum: 100 }
  validates :role, inclusion: { in: %w[customer admin] }
  
  has_many :cart_items, dependent: :destroy
  has_many :products_in_cart, through: :cart_items, source: :product
end
