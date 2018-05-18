class SupplyItemsController < ApplicationController
  layout 'base'

  before_action :find_project_by_project_id
  before_action :authorize

  menu_item :supply_items, only: [:index, :new, :create, :edit, :update, :destroy]

  def autocomplete
    @supply_items = @project.supply_items.like(params[:q]).to_a.map{|i|
      IssueSupplyItem.new supply_item: i, quantity: ''
    }
    render layout: false
  end

  def index
    @supply_items = SupplyItem.where project_id: @project.id
  end

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
        project_supply_items_path(@project)
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
      redirect_to project_supply_items_path(@project)
    else
      render 'edit'
    end
  end

  def destroy
    find_supply_item.destroy
    redirect_to project_supply_items_path(@project)
  end


  private

  def supply_item_params
    params[:supply_item].permit :name, :description, :unit
  end

  def find_supply_item
    @project.supply_items.find params[:id]
  end

end

