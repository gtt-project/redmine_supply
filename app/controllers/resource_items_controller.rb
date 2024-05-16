class ResourceItemsController < ApplicationController
  layout 'base'

  before_action :find_project_by_project_id
  before_action :authorize


  def index
    @resource_items = resource_class.where(project_id: @project.id)
      .includes(:category).references(:category)
      .sorted
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
      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_successful_update)
          redirect_to_index
        }
        format.js { head 200 }
      end
    else
      respond_to do |format|
        format.html {
          render 'edit'
        }
        format.js { head 422 }
      end
    end
  end

  def destroy
    @resource_item = find_resource_item
    if @resource_item.issues.empty?
      @resource_item.destroy
      respond_to do |format|
        format.html { redirect_to_index }
        format.api { render_api_ok }
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = error_can_not_delete_resource_item
          redirect_to_index
        end
        format.api { head :unprocessable_entity }
      end
    end
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
      parameters.permit :name, :category_id, :start_date, :end_date, :position
    end
  end

  def find_resource_item
    resource_class.where(project_id: @project.id).find params[:id]
  end

end



