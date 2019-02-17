class CreateResourceCategories < ActiveRecord::Migration[5.2]
  def up
    create_table :resource_categories do |t|
      t.references :project, null: false
      t.string :name, null: false
      t.timestamps null: false
    end unless table_exists?(:resource_categories)
  end

  def down
    drop_table :resource_categories
  end
end
