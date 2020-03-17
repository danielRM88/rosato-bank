class Account < ApplicationRecord
  belongs_to :user

  validates :balance, presence: true
  validates :user, presence: true
  validates :number, presence: true
  validates :number, length: { maximum: 50 }
end
