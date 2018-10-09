require 'redmine_supply/hooks'
require 'redmine_supply/view_hooks'

module RedmineSupply
  def self.setup
    RedmineSupply::IssuePatch.apply
    RedmineSupply::IssueQueryPatch.apply
    RedmineSupply::ProjectPatch.apply
    RedmineSupply::Patches::CustomFieldsHelperPatch.apply

    IssuesController.send :helper, :supply_items

    Unit.load File.join File.dirname(__FILE__), '../config/units.yml'
  end
end
