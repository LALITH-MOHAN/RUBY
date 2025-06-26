class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  validates :name, presence: true, length: { maximum: 100 }
  validates :role, inclusion: { in: %w[customer admin] }
end
