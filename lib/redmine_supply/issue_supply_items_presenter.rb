module RedmineSupply
  class IssueSupplyItemsPresenter < Presenter
    def initialize(scope)
      @scope = scope.
        includes(:supply_item).
        order("#{SupplyItem.table_name}.name ASC")
    end

    def call
      @scope.to_a.map{|isi| issue_supply_item_tag isi}
    end

    def to_s
      call.join ", ".html_safe
    end

    private

    def issue_supply_item_tag(issue_supply_item)
      item = issue_supply_item.supply_item
      "#{h item.name} (#{h issue_supply_item.quantity} #{h item.unit_name})"
    end
  end
end
