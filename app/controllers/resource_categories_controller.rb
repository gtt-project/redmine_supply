class ResourceCategoriesController < ApplicationController
  layout 'base'

  before_action :find_project_by_project_id
  before_action :authorize

  menu_item :settings

  def edit
    @resource_category = find_resource_category
  end

  def new
    @resource_category = ResourceCategory.new
  end

  def create
    r = RedmineResourceManager::SaveResourceCategory.(
      resource_category_params, project: @project
    )
    if r.category_saved?
      redirect_to params[:continue] ?
        new_project_resource_category_path(@project) :
        settings_project_path(@project, tab: 'resource_categories')
    else
      @resource_category = r.category
      render 'new'
    end
  end

  def update
    @resource_category = find_resource_category
    r = RedmineResourceManager::SaveResourceCategory.(resource_category_params,
                                             category: @resource_category)
    if r.category_saved?
      redirect_to settings_project_path(@project, tab: 'resource_categories')
    else
      render 'edit'
    end
  end

  def destroy
    find_resource_category.destroy
    redirect_to settings_project_path(@project, tab: 'resource_categories')
  end


  private

  def resource_category_params
    params[:resource_category].permit :name, :for_humans, :for_assets
  end

  def find_resource_category
    @project.resource_categories.find params[:id]
  end

end


