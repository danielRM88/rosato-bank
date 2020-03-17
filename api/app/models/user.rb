class User < ApplicationRecord
  has_secure_password
  
  has_many :accounts

  validates :user_name, presence: true
  validates :user_name, length: { maximum: 50 }
  validates :user_lastname, presence: true
  validates :user_lastname, length: { maximum: 50 }
  validates :email, presence: true
  validates :email, uniqueness: {case_sensitive: false}
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
end
