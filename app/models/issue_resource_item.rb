class IssueResourceItem < ActiveRecord::Base
  belongs_to :issue
  belongs_to :resource_item

  # breaks the nested assignment :()
  # validates :issue, presence: true
  validates :resource_item, presence: true
end
