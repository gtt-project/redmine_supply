module ResourceItemsHelper

  # renders items for the overlay
  def resource_item_form_tags(resource_items)
    safe_join resource_items.map{|i|
      resource_item_form_tag i
    } if resource_items
  end

  def resource_item_form_tag(resource_item)
    id = "new-#{dom_id resource_item}"
    content_tag :div, id: "#{id}_wrap", class: 'resource_item_wrap' do
      tags = [
        check_box_tag('resource_item_ids[]', resource_item.id,
                      false, id: id),
        content_tag(:label, resource_item.name, for: id),
      ]
      safe_join tags
    end
  end

  # renders items in the issue form
  def issue_resource_item_form_tags(issue_resource_items)
    safe_join issue_resource_items.map{|i|
      issue_resource_item_form_tag i
    } if issue_resource_items
  end

  def issue_resource_item_form_tag(issue_resource_item)
    resource_item = issue_resource_item.resource_item
    content_tag :p, id: dom_id(resource_item), class: 'issue_resource_item_wrap' do
      safe_join([
        content_tag(:span, resource_item.name),
        link_to('', '#', class: 'icon icon-del'),
        hidden_field_tag('issue[issue_resource_items_attributes][][resource_item_id]',  resource_item.id),
        hidden_field_tag('issue[issue_resource_items_attributes][][id]',
                         issue_resource_item.id),
        hidden_field_tag('issue[issue_resource_items_attributes][][_destroy]', '')

      ])
    end
  end
end

