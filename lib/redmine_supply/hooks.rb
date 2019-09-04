module RedmineSupply
  class Hooks < Redmine::Hook::Listener

    # injects formatted supply items array into json for mapfish printing
    def redmine_gtt_print_issue_to_json(context)
      issue = context[:issue]
      json = context[:json]
      attributes = json[:attributes] ||= {}

      attributes[:supply_items] = IssueSupplyItemsPresenter.(issue.issue_supply_items).join("\r\n")
      supply_items = IssueSupplyItemsPresenter.(issue.issue_supply_items)
      if supply_items.size > 5
        attributes[:supply_items_1] = supply_items[0..4].join("\r\n")
        attributes[:supply_items_2] = supply_items[5..-1].join("\r\n")
      else
        attributes[:supply_items_1] = supply_items.join("\r\n")
        attributes[:supply_items_2] = ""
      end
      items_by_type = issue.resource_items_by_type
      asset_resource_items_value = ""
      ResourceItemsPresenter.(items_by_type['asset']).each_with_index{|item, idx|
        if idx == 0
          asset_resource_items_value = item
        else
          if idx % 2 != 0
            asset_resource_items_value += "　 " + item
          else
            asset_resource_items_value += "\r\n" + item
          end
        end
      }
      attributes[:asset_resource_items] = asset_resource_items_value
      human_resource_items_value = ""
      ResourceItemsPresenter.(items_by_type['human']).each_with_index{|item, idx|
        if idx == 0
          human_resource_items_value = item
        else
          if idx % 5 != 0
            human_resource_items_value += "　 " + item
          else
            human_resource_items_value += "\r\n" + item
          end
        end
      }
      attributes[:human_resource_items] = human_resource_items_value
    end
  end
end
