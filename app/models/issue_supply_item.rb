class IssueSupplyItem < ActiveRecord::Base
  belongs_to :issue
  belongs_to :supply_item

  validates :supply_item, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }

  scope :sorted, ->{
    includes(:supply_item).order("#{SupplyItem.table_name}.name ASC")
  }

  after_destroy ->{
    RedmineSupply::RecordIssueSupplyItemChange.(issue,
                                                supply_item,
                                                quantity)
  }

  after_create ->{
    RedmineSupply::RecordIssueSupplyItemChange.(issue,
                                                supply_item,
                                                -1 * quantity)
  }

  after_update ->{
    if changes = saved_changes['quantity']
      quantity_was, quantity = changes
      RedmineSupply::RecordIssueSupplyItemChange.(issue,
                                                  supply_item,
                                                  quantity_was - quantity)
    end
  }


end
