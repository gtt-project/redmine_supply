# frozen_string_literal: true

require 'redmine_supply/hooks'
require 'redmine_supply/view_hooks'

module RedmineSupply
  def self.setup
    RedmineSupply::IssuePatch.apply
    RedmineSupply::IssueQueryPatch.apply
    RedmineSupply::ProjectPatch.apply
    RedmineSupply::Patches::CustomFieldsHelperPatch.apply

    IssuesController.send :helper, :supply_items
  end

  def self.unit_cf
    SupplyItemCustomField.find_by_name 'Unit'
  end
end
