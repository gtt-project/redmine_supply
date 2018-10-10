module RedmineResourceManager
  def self.setup
    RedmineResourceManager::IssuePatch.apply
    RedmineResourceManager::ProjectPatch.apply
    ProjectsController.send :helper, RedmineResourceManager::ProjectSettingsTabs
    IssuesController.send :helper, :resource_items
  end
end
