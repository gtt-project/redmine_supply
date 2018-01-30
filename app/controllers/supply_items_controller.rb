class SupplyItemsController < ApplicationController
  layout 'base'

  before_action :find_project_by_project_id
  before_action :authorize

  menu_item :settings, only: [:new, :create, :edit, :update, :destroy]

  def edit
    @supply_item = find_supply_item
  end

  def new
    @supply_item = SupplyItem.new
  end

  def create
    r = RedmineSupply::SaveSupplyItem.(supply_item_params,
                                          project: @project)
    if r.supply_item_saved?
      redirect_to params[:continue] ?
        new_project_supply_item_path(@project) :
        settings_project_path(@project, tab: 'supply_items')
    else
      @supply_item = r.supply_item
      render 'new'
    end
  end

  def update
    @supply_item = find_supply_item
    r = RedmineSupply::SaveSupplyItem.(supply_item_params,
                                          supply_item: @supply_item)
    if r.supply_item_saved?
      redirect_to settings_project_path(@project, tab: 'supply_items')
    else
      render 'edit'
    end
  end

  def destroy
    find_supply_item.destroy
    redirect_to settings_project_path(@project, tab: 'supply_items')
  end


  private

  def supply_item_params
    params[:supply_item].permit :name, :description, :unit
  end

  def find_supply_item
    @project.supply_items.find params[:id]
  end

  def find_project_by_project_id
    @project = Project.find params[:project_id]
  end

end

