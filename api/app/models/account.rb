class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions

  validates :balance, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
  validates :user, presence: true
  validates :number, presence: true
  validates :number, length: { maximum: 50 }
end
