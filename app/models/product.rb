class Product < ApplicationRecord
  has_many :order_items
  has_many :orders, through: :order_items

  validates :name, :price, :stock, presence: true
end
