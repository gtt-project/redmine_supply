module RedmineResourceManager
  class SaveResourceItem

    Result = ImmutableStruct.new :item_saved?, :item

    def self.call(*_)
      new(*_).call
    end

    def initialize(params, resource_class: nil,
                           item: resource_class.new,
                           project: )
      @params = params
      @item = item
      @project = project
    end


    def call
      if category_id = @params[:category_id].presence
        @item.category = @project.resource_categories.find category_id
      end
      @item.project = @project
      @item.name = @params[:name]
      @item.start_date = @params[:start_date]
      @item.end_date = @params[:end_date]

      return Result.new item_saved: @item.save,
                        item: @item
    end
  end
end


