class AddProjectIdToResourceItems < ActiveRecord::Migration[5.2]
  def up
    change_table :resource_items do |t|
      t.references :project
    end

    ResourceItem.includes(:category).find_each do |ri|
      ri.update_column :project_id, ri.category.project_id
    end

    change_column_null :resource_items, :project_id, false
  end

  def down
    remove_column :resource_items, :project_id
  end
end
