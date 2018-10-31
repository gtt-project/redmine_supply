# frozen_string_literal: true

require 'redmine_supply/hooks'
require 'redmine_supply/view_hooks'

module RedmineSupply
  def self.setup
    RedmineSupply::Patches::IssuePatch.apply
    RedmineSupply::Patches::IssueQueryPatch.apply
    RedmineSupply::Patches::ProjectPatch.apply
    RedmineSupply::Patches::CustomFieldsHelperPatch.apply

    IssuesController.send :helper, :supply_items
  end

  def self.unit_cf
    name = Setting.plugin_redmine_supply["unit_cf"].presence || "Unit"
    SupplyItemCustomField.find_by_name name
  end
end
