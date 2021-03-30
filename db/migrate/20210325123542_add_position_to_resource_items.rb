class AddPositionToResourceItems < ActiveRecord::Migration[5.2]
  def change
    add_column :resource_items, :position, :integer, default: 0
  end
end
