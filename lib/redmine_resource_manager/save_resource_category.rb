module RedmineResourceManager
  class SaveResourceCategory

    Result = ImmutableStruct.new :category_saved?, :category

    def self.call(*args, **kwargs)
      new(*args, **kwargs).call
    end

    def initialize(params, category: ResourceCategory.new,
                           project: category.project)
      @params = params
      @category = category
      @project = project
    end


    def call
      @category.project = @project
      @category.attributes = @params

      return Result.new category_saved: @category.save,
                        category: @category
    end
  end
end

