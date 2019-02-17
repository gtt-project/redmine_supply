class ChangeStockCountToDecimal < ActiveRecord::Migration[5.2]
  def change
    change_column :supply_items, :stock, :decimal, default: 0, null: false
    change_column :issue_supply_items, :quantity, :decimal, default: 0, null: false
    change_column :supply_item_journals, :old_stock, :decimal, default: 0, null: false
    change_column :supply_item_journals, :new_stock, :decimal
  end
end
