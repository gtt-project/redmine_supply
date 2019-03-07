module RedmineSupply
  class Hooks < Redmine::Hook::Listener

    # injects formatted supply items array into json for mapfish printing
    def redmine_gtt_print_issue_to_json(context)
      issue = context[:issue]
      json = context[:json]
      attributes = json[:attributes] ||= {}
      attributes[:supply_items] = IssueSupplyItemsPresenter.(issue.issue_supply_items).join("\r\n")
      attributes[:resource_items] = ResourceItemsPresenter.(issue.resource_items).join("\r\n")
    end
  end
end
