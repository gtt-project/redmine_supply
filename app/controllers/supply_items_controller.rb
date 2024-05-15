class SupplyItemsController < ApplicationController
  layout 'base'

  before_action :find_project_by_project_id
  before_action :authorize

  accept_api_auth :index, :show, :create, :update, :destroy

  helper :custom_fields

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

  def show
    @supply_item = find_supply_item
    respond_to do |format|
      format.html { head 406 }
      format.api
    end
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
    @supply_item = SupplyItem.new(project: @project)
  end

  def create
    r = RedmineSupply::SaveSupplyItem.(new_supply_item_params,
                                       project: @project)
    if r.supply_item_saved?

      respond_to do |format|
        format.html {
          redirect_to params[:continue] ?
            new_project_supply_item_path(@project) :
            project_supply_items_path(@project)
        }
        format.api  {
          @supply_item = r.supply_item
          render 'show', status: :created,
            location: project_supply_item_path(@project, @supply_item)
        }
      end
    else
      @supply_item = r.supply_item
      respond_to do |format|
        format.html { render 'new' }
        format.api  { render_validation_errors(@supply_item) }
      end
    end
  end

  def update
    @supply_item = find_supply_item
    r = RedmineSupply::SaveSupplyItem.(supply_item_params,
                                       supply_item: @supply_item)
    if r.supply_item_saved?
      respond_to do |format|
        format.html{
          redirect_to project_supply_items_path(@project)
        }
        format.api  { render_api_ok }
      end
    else
      respond_to do |format|
        format.html { render 'edit' }
        format.api  { render_validation_errors(@supply_item) }
      end
    end
  end

  def destroy
    @supply_item = find_supply_item
    if @supply_item.issues.empty?
      @supply_item.destroy
      respond_to do |format|
        format.html { redirect_to project_supply_items_path(@project) }
        format.api { render_api_ok }
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = l(:error_can_not_delete_supply_item)
          redirect_to project_supply_items_path(@project)
        end
        format.api  {head :unprocessable_entity}
      end
    end
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
      params[:supply_item].permit permitted_supply_item_parameters+[:stock]
    else
      {}
    end
  end

  def supply_item_params
    if params[:supply_item]
      params[:supply_item].permit permitted_supply_item_parameters
    else
      {}
    end
  end

  def find_supply_item
    @project.supply_items.find params[:id]
  end

  def permitted_supply_item_parameters
    cf_ids = [RedmineSupply.unit_cf&.id].compact.map(&:to_s)
    [:name, :description, custom_field_values: cf_ids]
  end

end

