class IssueResourceItemsController < ApplicationController

  before_action :find_project_by_project_id
  before_action :authorize

  helper :resource_items

  def new
    @issue = find_issue_if_present
    @type = %w(Asset Human).detect{|t| t == params[:type]}
    @categories = @project.resource_categories.sorted
    @categories = @type == 'Asset' ? @categories.for_assets : @categories.for_humans

    query = RedmineResourceManager::ResourceItemsQuery.new(
      project: @project, category_id: nil, issue_id: params[:issue_id],
      resource_class: @type.constantize
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

