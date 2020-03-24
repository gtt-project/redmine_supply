class AddMissingIndexesToIssueSupplyAndResourceItems < ActiveRecord::Migration[5.2]
  def self.up
    add_index :issue_supply_items, :issue_id
    add_index :issue_resource_items, :issue_id
  end

  def self.down
    remove_index :issue_supply_items, :issue_id
    remove_index :issue_resource_items, :issue_id
  end
end
