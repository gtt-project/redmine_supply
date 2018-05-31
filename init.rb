require 'redmine'

Rails.configuration.to_prepare do
  RedmineSupply.setup
end

Redmine::Plugin.register :redmine_supply do
  name 'Redmine Supply Plugin'
  author 'Jens Krämer, Georepublic'
  author_url 'https://hub.georepublic.net/gtt/redmine_supply'
  description 'Add configurable supply items to issues'
  version '1.1.0'

  requires_redmine version_or_higher: '3.4.0'

  project_module :supply do

    permission :manage_supply_items, {
      supply_items: %i( index new edit update create destroy ),
    }, require: :member

    permission :view_supply_items, {
      supply_items: %i( index ),
    }, require: :member

    permission :view_issue_supply_items, {}, require: :member, read: true
    permission :manage_issue_supply_items, {
      issue_supply_items: %i( new create destroy append ),
      supply_items: %i( autocomplete )
    }, require: :member
  end

  activity_provider :supply_item_journals, class_name: 'SupplyItemJournal'

  menu :project_menu,
    :supply_items,
    { controller: 'supply_items', action: 'index' },
    caption: :label_supply_item_plural,
    after: :issues,
    param: :project_id,
    permission: :view_supply_items

  menu :project_menu,
    :new_supply_item,
    { controller: 'supply_items', action: 'new' },
    caption: :label_supply_item_new,
    after: :new_version,
    param: :project_id,
    parent: :new_object,
    permission: :manage_supply_items
end

