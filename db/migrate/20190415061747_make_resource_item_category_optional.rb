class MakeResourceItemCategoryOptional < ActiveRecord::Migration[5.2]
  def up
    change_column_null :resource_items, :category_id, true
  end
  def down
    change_column_null :resource_items, :category_id, false
  end
end
