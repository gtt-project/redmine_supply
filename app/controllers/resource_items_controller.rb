class ResourceItemsController < ApplicationController
  layout 'base'

  before_action :find_project_by_project_id
  before_action :authorize

  menu_item :resource_items

  def index
    @resource_items = @project.resource_items
      .joins(:category)
      .order("#{ResourceCategory.table_name}.name ASC, #{ResourceItem.table_name} ASC")
  end

  def edit
    @resource_item = find_resource_item
  end

  def new
    @resource_item = ResourceItem.new resource_item_params
  end

  def create
    r = RedmineResourceManager::SaveResourceItem.(
      resource_item_params, project: @project
    )
    if r.item_saved?
      redirect_to params[:continue] ?
        new_project_resource_item_path(
          @project,
          resource_item: { category_id: r.item.category_id }
        ) :
        project_resource_items_path(@project)
    else
      @resource_item = r.item
      render 'new'
    end
  end

  def update
    @resource_item = find_resource_item
    r = RedmineResourceManager::SaveResourceItem.(
      resource_item_params, item: @resource_item, project: @project
    )
    if r.item_saved?
      redirect_to project_resource_items_path @project
    else
      render 'edit'
    end
  end

  def destroy
    find_resource_item.destroy
    redirect_to project_resource_items_path @project
  end

  def autocomplete
    query = RedmineResourceManager::ResourceItemsQuery.new(
      project: @project,
      category_id: params[:category_id],
      query: params[:q],
      issue_id: params[:issue_id]
    )
    @resource_items = query.scope
    @total = query.total
    render layout: false
  end

  private

  def resource_item_params
    params[:resource_item].permit :name, :category_id if params[:resource_item]
  end

  def find_resource_item
    @project.resource_items.find params[:id]
  end

end



