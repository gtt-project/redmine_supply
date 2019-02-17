class CreateSupplyItems < ActiveRecord::Migration[5.2]
  def change
    create_table :supply_items do |t|
      t.references :project, null: false
      t.string :name, null: false
      t.text :description
      t.integer :unit, default: 1
      t.timestamps null: false
    end
  end
end
