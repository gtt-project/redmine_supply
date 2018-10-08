class AddCommentToSupplyItemJournals < ActiveRecord::Migration
  def change
    add_column :supply_item_journals, :comment, :text
  end
end
