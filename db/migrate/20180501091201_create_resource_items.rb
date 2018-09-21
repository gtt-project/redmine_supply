class CreateResourceItems < ActiveRecord::Migration
  def up
    create_table :resource_items do |t|
      t.references :category, null: false
      t.string :name, null: false
      t.timestamps null: false
    end unless table_exists?(:resource_items)
  end

  def down
    drop_table :resource_items
  end
end

