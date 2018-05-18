module SupplyItemsHelper

  def unit_name(item)
    l :"label_supply_item_unit_#{item.unit}"
  end

  def issue_supply_item_tag(issue_supply_item)
    item = issue_supply_item.supply_item
    "#{item.name} (#{issue_supply_item.quantity} #{unit_name item})"
  end

  def issue_supply_item_form_tags(issue_supply_items)
    safe_join issue_supply_items.map{|i|
      issue_supply_item_form_tag i
    } if issue_supply_items
  end

  def issue_supply_item_form_tag(issue_supply_item)
    supply_item = issue_supply_item.supply_item
    id = dom_id supply_item
    content_tag :div, id: "#{id}_wrap", class: 'supply_item_wrap' do
      tags = [
        text_field_tag('issue[issue_supply_items_attributes][][quantity]',
                       issue_supply_item.quantity, id: id, size: 3),
        content_tag(:span, unit_name(supply_item), class: 'unit'),
        content_tag(:label, supply_item.name, for: id),
        hidden_field_tag('issue[issue_supply_items_attributes][][supply_item_id]',  supply_item.id)
      ]
      unless issue_supply_item.new_record?
        tags << hidden_field_tag(
          'issue[issue_supply_items_attributes][][id]',
          issue_supply_item.id
        )
      end
      safe_join tags
    end
  end
end
