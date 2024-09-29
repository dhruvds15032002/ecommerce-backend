class ListProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :stock
end
