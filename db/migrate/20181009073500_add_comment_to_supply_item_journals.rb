class AddCommentToSupplyItemJournals < ActiveRecord::Migration[5.2]
  def change
    add_column :supply_item_journals, :comment, :text
  end
end
