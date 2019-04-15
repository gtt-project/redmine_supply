class AddTypeToResourceItems < ActiveRecord::Migration[5.2]
  def change
    add_column :resource_items, :type, :string, null: false, default: 'Asset'
    change_column :resource_items, :type, :string, null: false, default: nil
  end
end
