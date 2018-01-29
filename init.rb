require 'redmine'

Rails.configuration.to_prepare do
  RedmineSupply.setup
end

Redmine::Plugin.register :redmine_supply do
  name 'Redmine Supply Plugin'
  author 'Jens Krämer, Georepublic'
  author_url 'https://hub.georepublic.net/gtt/redmine_supply'
  description 'Add configurable supply items to issues'
  version '1.0.0'

  requires_redmine version_or_higher: '3.4.0'

  #settings default: {
  #}, partial: 'redmine_supply/settings'

  project_module :supply do

    permission :view_supply_items, {}, require: :member, read: true
    permission :manage_supply_items, {
      supply_items: %i( new edit update create destroy ),
      projects: %i( manage_supply_items )
    }, require: :member
  end

end

