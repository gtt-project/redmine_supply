module RedmineResourceManager
  class SaveResourceItem

    Result = ImmutableStruct.new :item_saved?, :item

    def self.call(*_)
      new(*_).call
    end

    def initialize(params, item: ResourceItem.new,
                           project:)
      @params = params
      @item = item
      @project = project
    end


    def call
      if category_id = @params[:category_id]
        @item.category = @project.resource_categories.find category_id
      end
      @item.name = @params[:name]

      return Result.new item_saved: @item.save,
                        item: @item
    end
  end
end


