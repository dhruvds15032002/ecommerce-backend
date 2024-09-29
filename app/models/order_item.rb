class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, :price, presence: true
  validate :check_stock

  before_save :update_stock

  def check_stock
    errors.add(:quantity, "is greater than available stock") if product.stock < quantity
  end

  def update_stock
    product.update(stock: product.stock - quantity)
  end
end
