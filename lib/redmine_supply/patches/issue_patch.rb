module RedmineSupply
  module Patches
    module IssuePatch
      def self.apply
        unless Issue < self
          Issue.prepend self
          Issue.extend ClassMethods
          Issue.class_eval do

            has_many :issue_supply_items, dependent: :destroy
            after_destroy :delete_supply_item_journals

            accepts_nested_attributes_for :issue_supply_items

            safe_attributes 'issue_supply_items_attributes',
              if: ->(issue, user){ user.allowed_to?(:manage_issue_supply_items,
                                                    issue.project) }

          end

        end
      end

      def issue_supply_item_names
        cached_items = instance_variable_get("@issue_supply_items")
        if !cached_items.nil?
          IssueSupplyItemsPresenter.new(cached_items).to_s
          #instance_variable_set("@issue_supply_items", nil)
        else
          IssueSupplyItemsPresenter.new(issue_supply_items).to_s
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

      def delete_supply_item_journals
        SupplyItemJournal.where(issue_id: id).delete_all
      end
      private :delete_supply_item_journals

      module ClassMethods
        # Preloads issue supply items for a collection of issues
        def load_issue_supply_items(issues, user=User.current)
          if issues.any?
            issue_ids = issues.map(&:id)
            _issue_supply_items = IssueSupplyItem.includes(supply_item: [:custom_values]).
                                    where(:issue_id => issue_ids).
                                    order(:issue_id).
                                    order("#{SupplyItem.table_name}.name ASC").to_a
            issues.each do |issue|
              issue.instance_variable_set "@issue_supply_items",
                                          _issue_supply_items.select {|s| s.issue_id == issue.id}.
                                          map{|isi|
                                            IssueSupplyItem.new(
                                              id: isi.id,
                                              issue: issue,
                                              supply_item: SupplyItem.new(
                                                              id: isi.supply_item.id,
                                                              project: issue.project,
                                                              name: isi.supply_item.name,
                                                              description: isi.supply_item.description,
                                                              unit: isi.supply_item.unit,
                                                              stock: isi.supply_item.stock,
                                                              custom_values: [CustomValue.new(
                                                                id: isi.supply_item.custom_values.first.id,
                                                                customized_type: "SupplyItem",
                                                                customized_id: isi.supply_item.custom_values.first.customized_id,
                                                                custom_field_id: isi.supply_item.custom_values.first.custom_field_id,
                                                                value: isi.supply_item.custom_values.first.value
                                                              )]
                                                            ),
                                              quantity: isi.quantity
                                            )
                                          }.compact
            end
          end
        end
        # Preloads issue human resource items for a collection of issues
        def load_issue_human_resource_items(issues, user=User.current)
          if issues.any?
            issue_ids = issues.map(&:id)
            _issue_human_resource_items = IssueResourceItem.includes(:resource_item).
                                            where(resource_items: {type: "Human"}).
                                            where(:issue_id => issue_ids).to_a
            issues.each do |issue|
              issue.instance_variable_set "@issue_human_resource_items",
                                          _issue_human_resource_items.select {|h| h.issue_id == issue.id}.
                                          map{|iri|
                                              IssueResourceItem.new(
                                                issue: issue,
                                                resource_item: Human.new(
                                                                  id: iri.resource_item.id,
                                                                  category_id: iri.resource_item.category_id,
                                                                  name: iri.resource_item.name,
                                                                  project: issue.project
                                                                )
                                              )
                                          }.compact
            end
          end
        end
        # Preloads issue asset resource items for a collection of issues
        def load_issue_asset_resource_items(issues, user=User.current)
          if issues.any?
            issue_ids = issues.map(&:id)
            _issue_asset_resource_items = IssueResourceItem.includes(:resource_item).
                                            where(resource_items: {type: "Asset"}).
                                            where(:issue_id => issue_ids).to_a
            issues.each do |issue|
              issue.instance_variable_set "@issue_asset_resource_items",
                                          _issue_asset_resource_items.select {|a| a.issue_id == issue.id}.
                                          map{|iri|
                                            IssueResourceItem.new(
                                              issue: issue,
                                              resource_item: Asset.new(name: iri.resource_item.name)
                                            )
                                        }.compact
            end
          end
        end
      end
    end
  end
end
