class SupplyItemJournal < ActiveRecord::Base

  belongs_to :supply_item
  belongs_to :user

  validates :type, presence: true
  validates :supply_item, presence: true

  acts_as_event(
    title: ->(o){
      case o
      when SupplyItemCreation
        I18n.t :text_supply_item_created, name: o.name
      when SupplyItemUpdate
        I18n.t :text_supply_item_updated, name: o.name
      else
        I18n.t :text_supply_item_used, name: o.name
      end
    },
    description: ->(o){
      o.inspect
    },
    datetime: :created_at,
    url: ->(o){
      { controller: 'supply_items', action: 'index',
        project_id: o.supply_item.project.to_param }
    },
  )

  acts_as_activity_provider(
    scope: eager_load(:supply_item),
    author_key: 'supply_item_journals.user_id',
    timestamp: 'supply_item_journals.created_at',
    permission: :view_supply_items
  )


  def change
    new_stock - old_stock if new_stock && old_stock
  end
end
