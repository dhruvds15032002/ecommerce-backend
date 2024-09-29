class ChangeStatusToEnumInOrders < ActiveRecord::Migration[6.0]
  def up
    remove_column :orders, :status, :string

    add_column :orders, :status, :integer, default: 0
  end

  def down
    # Reverse the migration
    remove_column :orders, :status, :integer
    add_column :orders, :status, :string
  end
end
