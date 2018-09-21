class IssueResourceItemsController < ApplicationController

  before_filter :find_project_by_project_id
  before_filter :authorize

  helper :resource_items

  def new
    @categories = @project.resource_categories.sorted
    @category = @categories.first
    @issue = find_issue_if_present

    query = RedmineResourceManager::ResourceItemsQuery.new(
      project: @project, category_id: @category.id, issue_id: params[:issue_id]
    )

    @resource_items = query.scope
    @total = query.total
  end

  def create
    if ids = params[:resource_item_ids]
      @issue_resource_items = @project.resource_items.where(id: ids).map{|i|
        IssueResourceItem.new resource_item: i
      }
    end
    if @issue_resource_items.blank?
      head 200
    end
  end

  def destroy
  end

  private

  def find_issue_if_present
    if issue_id = params[:issue_id].presence
      @project.issues.visible.find issue_id
    end
  end
end

