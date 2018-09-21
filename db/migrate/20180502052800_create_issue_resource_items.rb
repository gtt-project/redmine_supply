class CreateIssueResourceItems < ActiveRecord::Migration
  def up
    create_table :issue_resource_items do |t|
      t.references :issue, null: false
      t.references :resource_item, null: false
    end unless table_exists?(:issue_resource_items)
  end

  def down
    drop_table :issue_resource_items
  end
end
