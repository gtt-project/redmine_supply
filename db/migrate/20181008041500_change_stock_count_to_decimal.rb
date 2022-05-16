class ChangeStockCountToDecimal < ActiveRecord::Migration[5.2]
  def up
    change_column :supply_items, :stock, :decimal, default: 0, null: false
    change_column :issue_supply_items, :quantity, :decimal, default: 0, null: false
    change_column :supply_item_journals, :old_stock, :decimal, default: 0, null: false
    change_column :supply_item_journals, :new_stock, :decimal
  end

  def down
    change_column :supply_items, :stock, :integer, default: 0, null: false
    change_column :issue_supply_items, :quantity, :integer, default: 0, null: false
    change_column :supply_item_journals, :old_stock, :integer, default: 0, null: false
    change_column :supply_item_journals, :new_stock, :integer
  end
end
