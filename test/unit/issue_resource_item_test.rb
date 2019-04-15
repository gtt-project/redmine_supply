require_relative '../test_helper'


class IssueResourceItemTest < ActiveSupport::TestCase
  fixtures :projects,
    :trackers,
    :projects_trackers,
    :enabled_modules,
    :issue_statuses,
    :issues,
    :enumerations,
    :custom_fields,
    :custom_values,
    :custom_fields_trackers

  def setup
    super
    User.current = nil
    Role.anonymous.add_permission! :manage_issue_resources

    @project = Project.find 'ecookbook'
    @project.enabled_modules.create! name: 'supply'

    @cat = @project.resource_categories.create! name: 'Car'
    @item = Asset.create! category: @cat, name: 'RCM 429'
    @issue = @project.issues.first

  end

  def test_new_issue_should_accept_nested_attributes
    i = Issue.new subject: 'test', project: @project,
      tracker_id: @project.trackers.first, author: User.anonymous,
      issue_resource_items_attributes: [
        { 'resource_item_id' => @item.id }
      ]

    assert i.save, i.errors.inspect
    i = Issue.find i.id
    assert_equal 1, i.resource_items.size
    assert_equal @item, i.resource_items.first
  end

  def test_should_remove_items
    i = Issue.create subject: 'test', project: @project,
      tracker_id: @project.trackers.first, author: User.anonymous,
      issue_resource_items_attributes: [
        { 'resource_item_id' => @item.id }
      ]

    i.reload
    assert i.resource_items.one?

    i.update_attributes issue_resource_items_attributes: [
      { id: i.issue_resource_items.first.id, _destroy: '1'}
    ]

    i.reload
    assert i.resource_items.none?

  end
end
