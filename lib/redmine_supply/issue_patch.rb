module RedmineSupply
  module IssuePatch
    def self.apply
      unless Issue < self
        Issue.prepend self

        Issue.class_eval do

          has_many :issue_supply_items

          def issue_supply_item_names
            IssueSupplyItemsPresenter.new(issue_supply_items).to_s
          end

          accepts_nested_attributes_for :issue_supply_items

          safe_attributes 'issue_supply_items_attributes',
            if: ->(issue, user){ user.allowed_to?(:manage_issue_supply_items,
                                                  issue.project) }

        end

      end
    end

    def issue_supply_items_attributes=(attributes = [])
      # remove items with zero quantity. existing items with zero quantity are
      # destroyed as well
      attributes = attributes.reject{ |hsh|
        id       = hsh['id']
        quantity = hsh['quantity'].to_f

        if quantity.zero?
          # an item is removed by setting it's quantity to zero
          if id
            issue_supply_items.where(id: id).destroy_all
          end
          true # remove this element
        elsif item = issue_supply_items
            .where(supply_item_id: hsh['supply_item_id']).first
          # set the new item quantity of an already existing record for this
          # item:
          item.update_attribute :quantity, quantity
          true # remove this element
        else
          false # keep it and let super handle it
        end
      }

      super attributes
    end

  end
end
