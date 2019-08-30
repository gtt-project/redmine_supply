class AddStartDateAndEndDateToResourceItems < ActiveRecord::Migration[5.2]
  def self.up
    add_column :resource_items, :start_date, :date
    add_column :resource_items, :end_date, :date
  end

  def self.down
    remove_column :resource_items, :start_date
    remove_column :resource_items, :end_date
  end
end
