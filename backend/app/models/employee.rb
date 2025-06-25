class Employee < ApplicationRecord
    validates :name, :role, presence: true
    validates :gender, inclusion: { in: %w[male female other], message: "%{value} is not a valid gender" }
  end
  