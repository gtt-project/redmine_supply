class HumanResourceItemsController < ResourceItemsController
  menu_item :human_resource_items

  def resource_class
    Human
  end

  def redirect_to_index
    redirect_to project_human_resource_items_path @project
  end
end
