class AddTimestampToSupplyItems < ActiveRecord::Migration
  def change
    change_table :supply_items do |t|
      t.timestamps null: true
    end
  end
end
