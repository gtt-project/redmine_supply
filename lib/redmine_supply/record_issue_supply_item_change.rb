module RedmineSupply
  class RecordIssueSupplyItemChange

    def self.call(*_)
      new(*_).call
    end

    # change is the numerical change of supply item quantity, i.e. if 5kg of
    # sand are added to an issue, this will be -5
    def initialize(issue, supply_item, change,
                   user: User.current || User.anonymous)
      @issue = issue
      @supply_item = supply_item
      @change = change
      @user = user
    end

    def call
      Rails.logger.error "\n@@@ supply_item #{@supply_item.name}: #{@change}"
      SupplyItem.transaction do
        item = SupplyItem.lock.find(@supply_item.id)
        new_stock = item.stock + @change
        IssueSupplyItemChange.create!(
          issue: @issue,
          user: @user,
          supply_item: item,
          old_stock: item.stock,
          new_stock: new_stock
        )
        item.update_column :stock, new_stock
      end
    end
  end
end
