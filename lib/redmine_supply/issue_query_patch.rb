module RedmineSupply
  module IssueQueryPatch

    def self.apply
      IssueQuery.prepend self unless IssueQuery < self
    end

    def available_columns
      return @available_columns if @available_columns

      super

      if User.current.allowed_to?(:view_issue_supply_items, project, global: true)
        @available_columns << QueryColumn.new(:issue_supply_item_names)
      end

      @available_columns
    end

    def add_supply_items(a)
      a | [:issue_supply_items]
    end

    def issues(options={})
      options[:include] = add_supply_items(options[:include] || [])
      super(options)
    end

    def issue_ids(options={})
      options[:include] = add_supply_items(options[:include] || [])
      super(options)
    end
  end
end
