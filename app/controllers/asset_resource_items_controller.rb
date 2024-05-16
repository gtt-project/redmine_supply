class AssetResourceItemsController < ResourceItemsController
  menu_item :asset_resource_items

  private

  def resource_class
    Asset
  end

  def redirect_to_index
    redirect_to project_asset_resource_items_path @project
  end

  def error_can_not_delete_resource_item
    l(:error_can_not_delete_asset_resource_item)
  end
end

