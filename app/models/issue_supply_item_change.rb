class IssueSupplyItemChange < SupplyItemJournal
  belongs_to :issue

  validates :issue, presence: true

  def activity_title
    I18n.t :text_issue_supply_item_changed, id: issue.id, name: supply_item.name, change: change_text
  end

  def activity_url
    {
      controller: 'issues',
      action: 'show',
      id: issue.to_param
    }
  end

  def change_text
    # we want to display the change on the issue, thus we have to inverse the item
    # stock change
    change = -1 * self.change
    if change > 0
      "+" + supply_item.stock_text(change)
    elsif change < 0
      supply_item.stock_text change
    else
      I18n.t :text_supply_item_nochange
    end
  end
end
