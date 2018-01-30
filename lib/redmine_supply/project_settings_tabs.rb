module RedmineSupply

  # hooks into the helper method that renders the project settings tabs
  module ProjectSettingsTabs

    def project_settings_tabs
      super.tap do |tabs|
        if User.current.allowed_to?(:manage_supply_items, @project)
          tabs << {
            name: 'supply_items',
            action: :manage_supply_items,
            partial: 'projects/settings/supply_items',
            label: :label_supply_item_plural
          }
        end
      end
    end

  end
end


