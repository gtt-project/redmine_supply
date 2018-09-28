module RedmineSupply
  class ResourceItemsPresenter < Presenter
    def initialize(scope)
      @scope = scope.
        order("#{ResourceItem.table_name}.name ASC")
    end

    def call
      @scope.to_a.map{|ri| item_tag ri}
    end

    def to_s
      call.join ", ".html_safe
    end

    private

    def item_tag(resource_item)
      h resource_item.name
    end

  end
end

