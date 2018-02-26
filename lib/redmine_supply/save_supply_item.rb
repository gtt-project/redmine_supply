module RedmineSupply
  class SaveSupplyItem

    Result = ImmutableStruct.new :supply_item_saved?, :supply_item

    def self.call(*_)
      new(*_).call
    end

    def initialize(params, supply_item: SupplyItem.new,
                           project: supply_item.project)
      @params = params
      @supply_item = supply_item
      @project = project
    end


    def call
      @supply_item.project = @project
      @supply_item.attributes = @params

      return Result.new supply_item_saved: @supply_item.save,
                        supply_item: @supply_item
    end
  end
end
