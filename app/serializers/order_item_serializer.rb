class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :product_id, :quantity, :price
end
