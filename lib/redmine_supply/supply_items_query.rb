module RedmineSupply
  class SupplyItemsQuery
    LIMIT = 10

    def initialize(project:, query: nil)
      @project = project
      @query = query.presence
    end

    def scope
      all.sorted.limit LIMIT
    end

    def to_a
      scope.to_a.map do |i|
        IssueSupplyItem.new supply_item: i, quantity: ''
      end
    end

    def total
      all.count
    end

    private

    def all
      all = @project.supply_items
      all = all.like @query if @query
      all
    end

  end
end
