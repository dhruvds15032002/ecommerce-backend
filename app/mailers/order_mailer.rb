class OrderMailer < ApplicationMailer
  default from: ENV['DEFAULT_FROM_EMAIL']

  def order_confirmation(user, order)
    @user = user
    @order = order
    mail(to: @user.email, subject: "Order Confirmation - ##{@order.id}")
  end

  def status_update(user, order)
    @user = user
    @order = order
    mail(to: @user.email, subject: "Order ##{order.id} Status Update - #{order.status.upcase}")
  end
end
