class SupplyItemsController < ApplicationController
  layout 'base'
  helper :custom_fields

  before_action :find_project_by_project_id
  before_action :authorize

  menu_item :supply_items, only: [:index, :new, :create, :edit, :update, :destroy]

  def autocomplete
    query = RedmineSupply::SupplyItemsQuery.new(project: @project,
                                                query: params[:q])
    @supply_items = query.to_a
    @total = query.total
    render layout: false
  end

  def index
    @supply_items = SupplyItem.order(name: :asc).where project_id: @project.id
  end

  def edit
    @supply_item = find_supply_item
    @history = RedmineSupply::SupplyItemHistory.new(
      @supply_item, page: params[:page], per_page: per_page_option
    )
  end

  def edit_stock
    @supply_item = find_supply_item
    @supply_item_stock_update = SupplyItemStockUpdate.new stock_change: 0.0
  end

  def update_stock
    @supply_item = find_supply_item
    @supply_item_stock_update = SupplyItemStockUpdate.new stock_change_params
    if @supply_item_stock_update.valid?
      r = RedmineSupply::UpdateStock.(@supply_item_stock_update,
                                      supply_item: @supply_item)
      if r.supply_item_saved?
        @location = edit_project_supply_item_path(@project, @supply_item)
      end
    end
  end

  def new
    @supply_item = SupplyItem.new
  end

  def create
    r = RedmineSupply::SaveSupplyItem.(new_supply_item_params,
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

  def stock_change_params
    if params[:supply_item_stock_update]
      params[:supply_item_stock_update].permit :stock_change, :comment
    else
      {}
    end
  end

  def new_supply_item_params
    if params[:supply_item]
      params[:supply_item].permit :name, :description, :unit, :stock
    else
      {}
    end
  end

  def supply_item_params
    if params[:supply_item]
      params[:supply_item].permit :name, :description, :unit
    else
      {}
    end
  end

  def find_supply_item
    @project.supply_items.find params[:id]
  end

end

