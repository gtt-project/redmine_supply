class HumanResourceItemsController < ResourceItemsController
  menu_item :human_resource_items

  private

  def resource_class
    Human
  end

  def redirect_to_index
    redirect_to project_human_resource_items_path @project
  end

  def error_can_not_delete_resource_item
    l(:error_can_not_delete_human_resource_item)
  end
end
