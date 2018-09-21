module RedmineResourceManager
  module ProjectSettingsTabs

    def project_settings_tabs
      super.tap do |tabs|
        if User.current.allowed_to?(:manage_resource_categories, @project)
          tabs << {
            name: 'resource_categories',
            partial: 'projects/settings/resource_categories',
            label: :label_resource_category_plural
          }
        end
      end
    end

  end
end
