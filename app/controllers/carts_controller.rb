class CartsController < ApplicationController

  before_action :set_cart, only: [:add_to_cart, :cart, :update_product_quantity, :remove_product_from_cart]
  before_action :set_cart_for_clearance, only: [:clear_cart]
  before_action :set_product, only: [:add_to_cart]

  def cart
    render json: { cart: @cart }, include: :cart_items
  end

  def add_to_cart
    cart_item = find_or_initialize_cart_item
    update_cart_item_quantity(cart_item)

    if cart_item.save
      @cart.update(total_price: @cart.total_price)
      render json: { message: "Product added to cart" }, status: :ok
    else
      render json: { message: "Failed to add product to cart" }, status: :unprocessable_entity
    end
  end

  def update_product_quantity
    cart_item = @cart.cart_items.find_by(product_id: params[:product_id])
    check_cart_item_exists(cart_item)
    if cart_item.update(quantity: params[:quantity])
      @cart.update(total_price: @cart.total_price)
      render json: @cart, status: :ok
    else
      render json: cart_item.errors, status: :unprocessable_entity
    end
  end

  def remove_product_from_cart
    cart_item = @cart.cart_items.find_by(product_id: params[:product_id])
    check_cart_item_exists(cart_item)
    if cart_item.destroy
      @cart.update(total_price: @cart.total_price)
      render json: @cart, status: :ok
    else
      render json: cart_item.errors, status: :unprocessable_entity
    end
  end

  def clear_cart
    if @cart.cart_items.destroy_all
      @cart.update(total_price: 0) # Reset the total price to 0
      render json: { message: "Cart cleared successfully" }, status: :ok
    else
      throw_error("Failed to clear the cart")
    end
  end

  private

  def set_cart
    @cart = Cart.find_or_create_by(user: @current_user)
  end

  def set_product
    @product = Product.find_by(id: params[:product_id])
    render json: { message: "Product not found" }, status: :not_found unless @product
  end

  def find_or_initialize_cart_item
    @cart.cart_items.find_or_initialize_by(product: @product)
  end

  def update_cart_item_quantity(cart_item)
    if cart_item.new_record?
      cart_item.quantity = params[:quantity] || 1
    else
      cart_item.quantity += params[:quantity].to_i
    end
  end

  def update_cart_total_price
    @cart.update(total_price: @cart.total_price)
  end

  def check_cart_item_exists(cart_item)
    render json: { message: "Product not in the cart" }, status: :not_found unless cart_item
  end

  def set_cart_for_clearance
    @cart = @current_user.cart
    throw_error("No cart found for this user") if @cart.blank?
  end
end
