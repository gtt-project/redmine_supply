module RedmineSupply
  class SaveSupplyItem

    Result = ImmutableStruct.new :supply_item_saved?, :supply_item, :error

    def self.call(*_)
      new(*_).call
    end

    def initialize(params, supply_item: SupplyItem.new,
                           project: supply_item.project,
                           user: User.current || User.anonymous)
      @params = params
      @supply_item = supply_item
      @project = project
      @user = user
    end


    def call
      @supply_item.project = @project
      @supply_item.attributes = @params

      SupplyItem.transaction do
        save_supply_item
      end

      if @error
        Result.new error: @error, supply_item: @supply_item
      else
        Result.new supply_item_saved: true, supply_item: @supply_item
      end
    end

    private

    def save_supply_item
      unless was_new = @supply_item.new_record?
        old_stock, new_stock = @supply_item.changes["stock"]
      end

      @supply_item.save!
      if was_new
        SupplyItemCreation.create!(
          supply_item: @supply_item, user: @user,
          old_stock: 0, new_stock: @supply_item.stock
        )
      elsif old_stock != new_stock
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
