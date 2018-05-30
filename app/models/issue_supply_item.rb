class IssueSupplyItem < ActiveRecord::Base
  belongs_to :issue
  belongs_to :supply_item

  validates :supply_item, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true,
                                                       greater_than: 0 }
end
