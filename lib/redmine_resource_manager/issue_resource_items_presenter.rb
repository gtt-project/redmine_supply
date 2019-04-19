module RedmineResourceManager
  class IssueResourceItemsPresenter < RedmineSupply::Presenter
    def initialize(scope)
      @scope = scope.sorted
    end

    def call
      @scope.to_a.map{|ri| issue_resource_item_tag ri}
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
