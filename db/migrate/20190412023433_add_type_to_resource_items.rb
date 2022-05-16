class AddTypeToResourceItems < ActiveRecord::Migration[5.2]
  def up
    add_column :resource_items, :type, :string, null: false, default: 'Asset'
    change_column :resource_items, :type, :string, null: false, default: nil
  end

  def down
    change_column :resource_items, :type, :string, null: false, default: 'Asset'
    remove_column :resource_items, :type, :string, null: false, default: 'Asset'
  end
end
