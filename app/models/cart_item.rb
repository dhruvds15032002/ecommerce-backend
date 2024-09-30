class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  before_save :set_price

  private

  def set_price
    self.price ||= product.price
  end
end
