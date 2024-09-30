class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy

   # Calculate total price of all cart items
   def total_price
    cart_items.sum { |item| item.price * item.quantity }
  end
end
