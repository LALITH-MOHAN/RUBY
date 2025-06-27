class Order < ApplicationRecord
    belongs_to :user
    has_many :order_items, dependent: :destroy
  
    validates :total, numericality: { greater_than_or_equal_to: 0 }
    validates :status, inclusion: { in: %w[pending paid shipped delivered cancelled] }
  
    def self.statuses
      %w[pending paid shipped delivered cancelled]
    end
  end