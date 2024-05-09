class SupplyItemJournal < (defined?(ApplicationRecord) == 'constant' ? ApplicationRecord : ActiveRecord::Base)

  belongs_to :supply_item
  belongs_to :user
  alias author user

  delegate :project, to: :supply_item

  validates :type, presence: true
  validates :supply_item, presence: true

  acts_as_event(
    title: :activity_title,
    description: '',
    datetime: :created_at,
    url: :activity_url
  )

  acts_as_activity_provider(
    scope: eager_load(supply_item: :project),
    author_key: 'supply_item_journals.user_id',
    timestamp: 'supply_item_journals.created_at',
    permission: :view_supply_items
  )


  # implement in subclasses
  def activity_title
    to_s
  end

  def activity_url
    {
      controller: 'supply_items',
      action: 'index',
      project_id: supply_item.project.to_param
    }
  end

  def change
    new_stock - old_stock if new_stock && old_stock
  end

end
