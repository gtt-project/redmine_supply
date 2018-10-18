module SupplyItemsHelper

  def issue_supply_item_form_tags(issue_supply_items)
    safe_join issue_supply_items.map{|i|
      issue_supply_item_form_tag i
    } if issue_supply_items
  end

  def issue_supply_item_form_tag(issue_supply_item, label: false, deletable: false)
    supply_item = issue_supply_item.supply_item
    id = dom_id supply_item
    content_tag :p, id: "#{id}_wrap", class: 'issue_supply_item_wrap' do
      tags = [
        content_tag(:label, supply_item.name, for: id, class: "supply-item"),
        text_field_tag('issue[issue_supply_items_attributes][][quantity]',
                       issue_supply_item.quantity, id: id, size: 3),
        content_tag(:span, supply_item.unit_name, class: 'unit'),
      ]
      tags << link_to('', '#', class: 'icon icon-del') if deletable
      tags << hidden_field_tag('issue[issue_supply_items_attributes][][supply_item_id]',  supply_item.id)
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
