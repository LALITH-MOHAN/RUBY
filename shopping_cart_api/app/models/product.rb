class Product < ApplicationRecord
    has_many :cart_items
    has_many :users, through: :cart_items
    has_many :order_items
    has_many :orders, through: :order_items
  end