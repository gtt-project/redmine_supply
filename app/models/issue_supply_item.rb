class IssueSupplyItem < ActiveRecord::Base
  belongs_to :issue
  belongs_to :supply_item

  validates :supply_item, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }

  after_destroy ->(isi){
    RedmineSupply::RecordIssueSupplyItemChange.(isi.issue,
                                                isi.supply_item,
                                                isi.quantity)
  }

  after_create ->(isi){
    RedmineSupply::RecordIssueSupplyItemChange.(isi.issue,
                                                isi.supply_item,
                                                -1 * isi.quantity)
  }

  after_update ->(isi){
    if isi.quantity_was != isi.quantity
      RedmineSupply::RecordIssueSupplyItemChange.(isi.issue,
                                                  isi.supply_item,
                                                  isi.quantity_was - isi.quantity)
    end
  }


end
