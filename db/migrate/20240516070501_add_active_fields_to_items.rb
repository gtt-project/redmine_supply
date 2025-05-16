class AddActiveFieldsToItems < ActiveRecord::Migration[5.2]
  def self.up
    add_column :supply_items, :active, :boolean, :default => true, :null => false
    add_column :resource_items, :active, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :supply_items, :active
    remove_column :resource_items, :active
  end
end
