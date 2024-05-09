module RedmineSupply
  class IssueSupplyItemsPresenter < Presenter
    def initialize(obj)
      if obj.instance_of?(Array)
        @scope = nil
        @issue_supply_items = obj
      else
        @scope = obj.sorted
        @issue_supply_items = @scope.to_a
      end
    end

    def call
      @issue_supply_items.map{|isi| issue_supply_item_tag isi}
    end

    def to_s
      call.join ", ".html_safe
    end

    private

    def issue_supply_item_tag(issue_supply_item)
      item = issue_supply_item.supply_item
      if item.nil?
        return ""
      end
      "#{h item.name} (#{h issue_supply_item.quantity} #{h item.unit_name})"
    end
  end
end
