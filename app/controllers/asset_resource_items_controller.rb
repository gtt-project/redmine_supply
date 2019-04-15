class AssetResourceItemsController < ResourceItemsController
  menu_item :asset_resource_items

  def resource_class
    Asset
  end

  def redirect_to_index
    redirect_to project_asset_resource_items_path @project
  end
end

