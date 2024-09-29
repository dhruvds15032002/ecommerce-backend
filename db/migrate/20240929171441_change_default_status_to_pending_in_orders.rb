class ChangeDefaultStatusToPendingInOrders < ActiveRecord::Migration[6.0]
  def change
    change_column_default :orders, :status, from: 0, to: 0
  end
end
