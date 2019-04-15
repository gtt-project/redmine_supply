require_relative '../test_helper'

class IssueResourceItemsTest < Redmine::IntegrationTest
  fixtures :users, :email_addresses, :user_preferences,
    :roles, :projects, :members, :member_roles,
    :trackers,
    :projects_trackers,
    :enabled_modules,
    :issue_statuses,
    :issues,
    :enumerations,
    :custom_fields,
    :custom_values,
    :custom_fields_trackers,
    :attachments

  def setup
    super
    User.current = nil

    @project = Project.find 'ecookbook'
    @project.enabled_modules.create! name: 'supply'

    @cat = @project.resource_categories.create! name: 'Car'
    @item = Asset.create! project: @project, category: @cat, name: 'RCM 429'
    @issue = @project.issues.first

  end

  def test_viewing_issue_resource_items_requires_manage_permission
    log_user 'jsmith', 'jsmith'

    @issue.issue_resource_items.create! resource_item: @item

    get "/issues/#{@issue.id}"
    assert_response :success
    assert_select 'div.label', text: 'Assets:', count: 0
    assert_select 'div.value', text: 'RCM 429', count: 0

    Role.find(1).add_permission! :view_issue_resources

    get "/issues/#{@issue.id}"
    assert_response :success
    assert_select 'div.label', text: 'Assets:'
    assert_select 'div.value', text: 'RCM 429'
  end

  def test_editing_issue_resource_items_requires_manage_permission
    log_user 'jsmith', 'jsmith'

    get '/projects/ecookbook/issues/new'
    assert_response :success
    assert_select 'label', text: 'Assets', count: 0
    assert_select '.add_resource_items a', text: 'Add', count: 0

    get '/issues/1/edit'
    assert_response :success
    assert_select 'label', text: 'Assets', count: 0
    assert_select '.add_resource_items a', text: 'Add', count: 0

    Role.find(1).add_permission! :manage_issue_resources
    Role.find(1).add_permission! :view_issue_resources
    get '/projects/ecookbook/issues/new'
    assert_response :success
    assert_select 'label', text: 'Assets'
    assert_select '.add_resource_items a', text: 'Add'

    get '/issues/1/edit'
    assert_response :success
    assert_select 'label', text: 'Assets'
    assert_select '.add_resource_items a', text: 'Add'
  end

  def test_issue_resource_items_editing
    item2 = Asset.create! project: @project, category: @cat, name: 'ASL-JJ 262'
    Role.find(1).add_permission! :manage_issue_resources
    Role.find(1).add_permission! :view_issue_resources
    log_user 'jsmith', 'jsmith'

    get '/projects/ecookbook/issues/new'
    assert_response :success

    get '/projects/ecookbook/issue_resource_items/new', xhr: true, params: { type: 'Asset' }
    assert_response :success

    post '/projects/ecookbook/issues', params: {
      issue: {
        subject: 'test',
        issue_resource_items_attributes: [
          {"resource_item_id" => @item.id.to_s}
        ]
      }
    }

    @item.reload
    assert_equal 1, @item.issue_resource_items.count
    assert issue_resource_item = @item.issue_resource_items.first
    assert issue = issue_resource_item.issue
    assert_equal 'test', issue.subject

    follow_redirect!
    assert_response :success
    assert_select 'div.label', text: 'Assets:'
    assert_select 'div.value', text: /RCM 429/

    get "/issues/#{issue.id}/edit"
    assert_response :success
    assert_select 'label', text: 'Assets'
    assert_select 'p.issue_resource_item_wrap', text: /RCM 429/


    put "/issues/#{issue.id}", params: {
      issue: {
        issue_resource_items_attributes: [
          { id: issue_resource_item.id,
            resource_item_id: issue_resource_item.resource_item_id },
          { "resource_item_id" => item2.id }
        ]
      }
    }

    issue.reload
    assert_equal 2, issue.resource_items.count
    other_item = issue.issue_resource_items.where(resource_item_id: item2.id).first


    follow_redirect!
    assert_response :success
    assert_select 'div.label', text: 'Assets:'
    assert_select 'div.value', text: /RCM 429/
    assert_select 'div.value', text: /ASL-JJ 262/


    put "/issues/#{issue.id}", params: {
      issue: {
        issue_resource_items_attributes: [
          { id: issue_resource_item.id,
            resource_item_id: issue_resource_item.resource_item_id },
          { id: other_item.id, _destroy: '1'}
        ]
      }
    }

    issue.reload
    assert_equal 1, issue.resource_items.count

    follow_redirect!

    assert_response :success
    assert_select 'div.label', text: 'Assets:'
    assert_select 'div.value', text: /RCM 429/
    assert_select 'div.value', text: /ASL-JJ 262/, count: 0

    put "/issues/#{issue.id}", params: {
      issue: {
        issue_resource_items_attributes: [
          { id: issue.issue_resource_items.last.id, _destroy: '1'}
        ]
      }
    }

    refute IssueResourceItem.any?

    follow_redirect!
    assert_response :success
    assert_select 'label', text: 'Assets'
    assert_select 'div.issue_resource_item_wrap', text: /RCM 429/, count: 0
    assert_select 'div.issue_resource_item_wrap', text: /ASL-JJ 262/, count: 0

  end
end


