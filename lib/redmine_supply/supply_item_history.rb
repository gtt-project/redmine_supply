module RedmineSupply
  class SupplyItemHistory
    class HistoryItem
      include Redmine::I18n

      def initialize(journal)
        @journal = journal
      end

      def created_at
        format_date @journal.created_at
      end

      def change
        if change = @journal.change
          Quantity.new change
        end
      end

      def new_stock
        Quantity.new @journal.new_stock
      end

      def comment
        if @journal.comment.present?
          @journal.comment
        elsif @journal.is_a? SupplyItemCreation
          l :text_supply_item_journal_created
        end
      end

      def issue
        @journal.issue if @journal.respond_to? :issue
      end
    end

    def initialize(supply_item, page: 1, per_page: 50)
      @item = supply_item
      @page = page.to_i
      @per_page = per_page.to_i
    end

    def journals
      journals = scope.order(created_at: :desc).
        offset(paginator.offset).
        limit(paginator.per_page)
      journals.to_a.map{|j| HistoryItem.new j}
    end

    def pages
      paginator.pages
    end

    def paginator
      @paginator ||= Redmine::Pagination::Paginator.new count, @per_page, @page
    end

    def count
      scope.count
    end

    def any?
      scope.any?
    end

    private

    def scope
      @scope ||= @item.journals
    end
  end
end
