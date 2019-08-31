class ResourceItemsController < ApplicationController
  layout 'base'

  before_action :find_project_by_project_id
  before_action :authorize


  def index
    @resource_items = resource_class.where(project_id: @project.id)
      .includes(:category).references(:category)
      .order("#{ResourceCategory.table_name}.name ASC, #{ResourceItem.table_name}.name ASC")
  end

  def edit
    @resource_item = find_resource_item
  end

  def new
    @resource_item = resource_class.new resource_item_params
  end

  def create
    r = RedmineResourceManager::SaveResourceItem.(
      resource_item_params, project: @project, resource_class: resource_class
    )
    if r.item_saved?
      if params[:continue]
        redirect_to new_project_resource_item_path(
          @project,
          resource_item: { category_id: r.item.category_id }
        )
      else
        redirect_to_index
      end
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
      redirect_to_index
    else
      render 'edit'
    end
  end

  def destroy
    find_resource_item.destroy
    redirect_to_index
  end

  def autocomplete
    query = RedmineResourceManager::ResourceItemsQuery.new(
      resource_class: resource_class,
      project: @project,
      category_id: params[:category_id],
      query: params[:q],
      issue_id: params[:issue_id],
    )
    @resource_items = query.scope
    @total = query.total
    render 'resource_items/autocomplete', layout: false
  end

  private

  def resource_class
    if type = %w(Asset Human).detect{|t|t == params[:type]}
      type.constantize
    end
  end

  def resource_item_params
    if parameters = params[:human] || params[:asset]
      parameters.permit :name, :category_id, :start_date, :end_date
    end
  end

  def find_resource_item
    resource_class.where(project_id: @project.id).find params[:id]
  end

end



