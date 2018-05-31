class SupplyItemCreation < SupplyItemJournal

  def title
    I18n.t :text_supply_item_created, name: supply_item.name, stock: supply_item.stock_text
  end
end
