module RedmineResourceManager
  class IssueResourceItemsPresenter < RedmineSupply::Presenter
    def initialize(obj)
      if obj.instance_of?(Array)
        @scope = nil
        @issue_resource_items = obj
      else
        @scope = obj.sorted
        @issue_resource_items = @scope.to_a
      end
    end

    def call
      @issue_resource_items.map{|ri| issue_resource_item_tag ri}
    end

    def to_s
      call.join ", ".html_safe
    end

    private

    def issue_resource_item_tag(issue_resource_item)
      h issue_resource_item.resource_item.name
    end

  end
end
