module SupplyItemsHelper
  def issue_supply_item_tags(issue_supply_items)
    safe_join issue_supply_items.map{|i|
      supply_item = i.supply_item
      id = dom_id supply_item
      content_tag :div, id: "#{id}_wrap", class: 'supply_item_wrap' do
        text_field_tag('issue[issue_supply_items_attributes][][quantity]',
                       i.quantity, id: id, size: 3) +
        content_tag(:span, t(:"label_supply_item_unit_#{supply_item.unit}"), class: 'unit') +
        content_tag(:label, supply_item.name, for: id) +
        hidden_field_tag('issue[issue_supply_items_attributes][][supply_item_id]',  supply_item.id)
      end
    } if issue_supply_items
  end
end
