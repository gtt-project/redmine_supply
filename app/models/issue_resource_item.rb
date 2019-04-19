class IssueResourceItem < ActiveRecord::Base
  belongs_to :issue
  belongs_to :resource_item

  scope :sorted, ->{
    includes(:resource_item).order("#{ResourceItem.table_name}.name ASC")
  }

  # breaks the nested assignment :()
  # validates :issue, presence: true
  validates :resource_item, presence: true

end

