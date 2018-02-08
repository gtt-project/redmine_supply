require 'redmine_supply/view_hooks'

module RedmineSupply
  def self.setup
    RedmineSupply::IssuePatch.apply
    RedmineSupply::ProjectPatch.apply
    ProjectsController.send :helper, RedmineSupply::ProjectSettingsTabs
    IssuesController.send :helper, :supply_items
  end
end