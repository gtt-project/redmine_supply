class SupplyItemUpdate < SupplyItemJournal

  def title
    I18n.t :text_supply_item_updated, name: supply_item.name, change: change_text
  end

  def change_text
    if change > 0
      "+#{change} #{supply_item.unit_name}"
    elsif change < 0
      "#{change} #{supply_item.unit_name}"
    else
      I18n.t :text_supply_item_nochange
    end

  end

end
