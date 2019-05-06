module RedmineSupply
  class Hooks < Redmine::Hook::Listener

    # injects formatted supply items array into json for mapfish printing
    def redmine_gtt_print_issue_to_json(context)
      issue = context[:issue]
      json = context[:json]
      attributes = json[:attributes] ||= {}
      attributes[:supply_items] = IssueSupplyItemsPresenter.(issue.issue_supply_items).join("\r\n")
      items_by_type = issue.resource_items_by_type
      attributes[:asset_resource_items] = ResourceItemsPresenter.(items_by_type['asset']).join("\r\n")
      attributes[:human_resource_items] = ResourceItemsPresenter.(items_by_type['human']).join("\r\n")
    end
  end
end
