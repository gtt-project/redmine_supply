module RedmineSupply
  class UpdateStock < Action

    Result = ImmutableStruct.new :supply_item_saved?, :error

    def initialize(change, supply_item:,
                           user: User.current || User.anonymous)
      @change = change.to_f
      @supply_item = supply_item
      @user = user
    end

    def call
      @supply_item.stock = @supply_item.stock + @change
      SupplyItem.transaction do
        save_supply_item
      end

      if @error
        Result.new error: @error
      else
        Result.new supply_item_saved: true
      end
    end

    private

    def save_supply_item
      old_stock, new_stock = @supply_item.changes["stock"]
      @supply_item.save!
      unless old_stock == new_stock
        SupplyItemUpdate.create!(
          supply_item: @supply_item, user: @user,
          old_stock: old_stock, new_stock: new_stock
        )
      end
    rescue ActiveRecord::RecordInvalid
      @error = $!.message
      raise ActiveRecord::Rollback
    end
  end
end
