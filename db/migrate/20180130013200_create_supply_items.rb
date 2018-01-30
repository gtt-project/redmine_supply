class CreateSupplyItems < ActiveRecord::Migration
  def change
    create_table :supply_items do |t|
      t.references :project
      t.string :name, null: false
      t.text :description
      t.integer :unit, default: 1
    end
  end
end
