class AddStockCountToSupplyItems < ActiveRecord::Migration
  def change
    add_column :supply_items, :stock, :integer, default: 0, null: false
  end
end
