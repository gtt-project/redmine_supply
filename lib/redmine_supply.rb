require 'redmine_supply/view_hooks'

module RedmineSupply
  def self.setup
    RedmineSupply::ProjectPatch.apply
    ProjectsController.send :helper, RedmineSupply::ProjectSettingsTabs
  end
end
