class CreateIssueSupplyItems < ActiveRecord::Migration
  def change
    create_table :issue_supply_items do |t|
      t.references :issue, null: false
      t.references :supply_item, null: false
      t.integer :quantity, default: 1
    end
  end
end
