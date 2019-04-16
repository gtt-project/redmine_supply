class AddUsageFlagsToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :resource_categories, :for_assets, :boolean, default: false
    add_column :resource_categories, :for_humans, :boolean, default: false
    ResourceCategory.where(id: Asset.pluck(:category_id).uniq).update_all for_assets: true
    ResourceCategory.where(id: Human.pluck(:category_id).uniq).update_all for_humans: true
    ResourceCategory.where(for_humans: false, for_assets: false).update_all for_assets: true
  end
end
