class IssueSupplyItemChange < SupplyItemJournal
  belongs_to :issue

  validates :issue, presence: true

end
