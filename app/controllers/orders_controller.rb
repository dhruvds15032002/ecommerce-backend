class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update_status]
  before_action :set_cart, only: [:checkout]

  def index
    orders = @current_user.orders
    if orders.present?
      render json: orders, each_serializer: OrderSerializer
    else
      render json: { error: "No orders found for this user" }, status: :not_found
    end
  end

  def show
    render json: @order, serializer: OrderSerializer
  end

  def create
    order = Order.new(order_params)
    order.user_id = params[:user_id]
    if order.save
      OrderMailer.order_confirmation(order.user, order).deliver_later
      render json: order, status: :created
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  def checkout
    cart_items = @cart&.cart_items
    throw_error("No cart items found for this user") if cart_items.blank?
    order = Order.new(checkout_params)
    order.user_id = @current_user.id
    order.total_price = @cart.total_price

    cart_items.each do |cart_item|
      order.order_items.build(product_id: cart_item.product_id, quantity: cart_item.quantity, price: cart_item.price * cart_item.quantity)
    end

    if order.save
      cart_items.destroy_all
      OrderMailer.order_confirmation(@current_user, order).deliver_later
      render json: order, serializer: OrderSerializer
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  def update_status
    if @order.update(status: params[:status])
      OrderMailer.status_update(@order.user, @order).deliver_later
      render json: { message: "Order status updated to #{@order.status.upcase}" }, status: :ok
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      render json: { error: "Order not found" }, status: :not_found
    end
  end

  def order_params
    params.require(:order).permit(:status, :total_price, order_items_attributes: [:product_id, :quantity, :price])
  end

  def checkout_params
    params.require(:order).permit(:status)
  end

  def set_cart
    @cart = @current_user.cart
    throw_error("No cart found for this user") if @cart.blank?
  end
end
