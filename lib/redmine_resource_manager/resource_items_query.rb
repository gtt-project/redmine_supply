module RedmineResourceManager
  class ResourceItemsQuery
    LIMIT = 10

    def initialize(project:, query: nil, category_id: nil, issue_id: nil)
      @project = project
      @query = query.presence
      @category_id = category_id.presence
      @issue_id = issue_id.presence
    end

    def scope
      all.sorted.limit LIMIT
    end

    # size before applying limit
    def total
      all.size
    end

    private

    def all
      all = @project.resource_items
      all = all.where(category_id: @category_id) if @category_id
      all = all.like @query if @query
      if @issue_id
        issue = @project.issues.visible.find @issue_id
        all = all.where.not(id: issue.resource_item_ids)
      end
      all
    end

  end
end
