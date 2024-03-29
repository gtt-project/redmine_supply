class IssueSupplyItemsController < ApplicationController

  before_action :find_project_by_project_id
  before_action :authorize

  helper :supply_items

  def new
    query = RedmineSupply::SupplyItemsQuery.new(project: @project)
    @supply_items = query.to_a
    @total = query.total
  end

  def create
    if params[:issue] and attrs = params[:issue][:issue_supply_items_attributes]

      @issue_supply_items = attrs.map{ |hsh|
        if i = @project.supply_items.find_by_id(hsh[:supply_item_id]) and
          (quantity = hsh[:quantity].to_f) > 0

          IssueSupplyItem.new supply_item: i, quantity: quantity
        end
      }.compact
    end
    if @issue_supply_items.blank?
      head 200
    end
  end

  def destroy
  end

end
