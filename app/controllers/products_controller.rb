class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  def index
    products = Product.all
    render json: products, each_serializer: ListProductSerializer
  end

  def show
    render json: @product, serializer: ProductSerializer
  end

  def create
    product = Product.new(product_params)
    if product.save
      render json: product, serializer: ProductSerializer, status: :created
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: @product, serializer: ProductSerializer
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    head :no_content
  end

  private

  def set_product
    @product = Product.find_by(id: params[:id])
    render json: { error: "Product not found" }, status: :not_found unless @product
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock)
  end
end
