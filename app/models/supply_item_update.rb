# frozen_string_literal: true
#
class SupplyItemUpdate < SupplyItemJournal

  def activity_title
    I18n.t :text_supply_item_updated, name: supply_item.name, change: change_text
  end

  def change_text
    if change > 0
      "+" + supply_item.stock_text(change)
    elsif change < 0
      supply_item.stock_text change
    else
      I18n.t :text_supply_item_nochange
    end
  end

end
