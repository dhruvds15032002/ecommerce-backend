class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  enum status: { pending: 0, shipped: 1, delivered: 2, cancelled: 3 }
  accepts_nested_attributes_for :order_items

  validates :status, presence: true
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  before_save :calculate_total_price

  def calculate_total_price
    self.total_price = order_items.sum { |item| item.price * item.quantity }
  end
end
