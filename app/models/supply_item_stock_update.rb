class SupplyItemStockUpdate
  include ActiveModel::Model

  attr_accessor :stock_change

  validates :stock_change, presence: true, numericality: { other_than: 0 }

end
