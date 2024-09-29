class OrderSerializer < ActiveModel::Serializer
  attributes :id, :status, :total_price, :created_at

  has_many :order_items, serializer: OrderItemSerializer
end
