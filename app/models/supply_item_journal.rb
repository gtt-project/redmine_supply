class SupplyItemJournal < ActiveRecord::Base

  belongs_to :supply_item
  belongs_to :user
  alias author user

  delegate :project, to: :supply_item

  validates :type, presence: true
  validates :supply_item, presence: true

  acts_as_event(
    title: :title,
    description: '',
    datetime: :created_at,
    url: ->(o){
      { controller: 'supply_items', action: 'index',
        project_id: o.supply_item.project.to_param }
    },
  )

  acts_as_activity_provider(
    scope: eager_load(supply_item: :project),
    author_key: 'supply_item_journals.user_id',
    timestamp: 'supply_item_journals.created_at',
    permission: :view_supply_items
  )


  # implement in subclasses
  def title
    to_s
  end

  def change
    new_stock - old_stock if new_stock && old_stock
  end
end
