class CreateSupplyItemJournals < ActiveRecord::Migration
  def change
    create_table :supply_item_journals do |t|
      t.string  :type, index: true, null: false
      t.integer :old_stock, null: false, default: 0
      t.integer :new_stock
      t.references :supply_item, index: true, null: false
      t.references :user, index: true, null: false
      t.references :issue
      t.timestamps null: false
    end
  end
end
