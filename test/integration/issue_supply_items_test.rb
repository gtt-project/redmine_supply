require_relative '../test_helper'

class IssueSupplyItemsTest < Redmine::IntegrationTest
  fixtures :projects,
           :users, :email_addresses,
           :roles,
           :members,
           :member_roles,
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
    EnabledModule.create! project: @project, name: 'supply'
    Role.find(1).add_permission! :view_issue_supply_items
  end

  def test_editing_supply_items_require_manage_permission
    log_user 'jsmith', 'jsmith'

    get '/projects/ecookbook/issues/new'
    assert_response :success
    assert_select 'label', text: 'Supply items', count: 0
    assert_select '.add_supply_items a', text: 'Add', count: 0

    get '/issues/1/edit'
    assert_response :success
    assert_select 'label', text: 'Supply items', count: 0
    assert_select '.add_supply_items a', text: 'Add', count: 0
  end

  def test_issue_supply_items_editing
    Role.find(1).add_permission! :manage_issue_supply_items
    log_user 'jsmith', 'jsmith'

    sand = SupplyItem.generate! name: 'Sand', project: @project, unit: 'kg'


    get '/projects/ecookbook/issues/new'
    assert_response :success
    assert_select 'label', text: 'Supply items'
    assert_select '.add_supply_items a', text: 'Add'

    post '/projects/ecookbook/issues', params: {
      issue: {
        subject: 'test',
        issue_supply_items_attributes: [
          {"quantity"=>"10.5", "supply_item_id"=>sand.id.to_s}
        ]
      }
    }

    sand.reload
    assert_equal 1, sand.issue_supply_items.count
    assert issue_supply_item = sand.issue_supply_items.first
    assert_equal 10.5, issue_supply_item.quantity
    assert issue = issue_supply_item.issue
    assert_equal 'test', issue.subject

    follow_redirect!
    assert_response :success
    assert_select 'label', text: 'Supply items'
    assert_select 'div.value', text: 'Sand (10.5 kg)'

    get "/issues/#{issue.id}/edit"
    assert_response :success
    assert_select "#supply_item_#{sand.id}_wrap input[value=\"10.5\"]"
    assert_select "#supply_item_#{sand.id}_wrap label", text: 'Sand'


    put "/issues/#{issue.id}", params: {
      issue: {
        issue_supply_items_attributes: [
          { "quantity" => "15", "id" => issue_supply_item.id }
        ]
      }
    }

    issue_supply_item.reload
    assert_equal 15, issue_supply_item.quantity

    follow_redirect!
    assert_response :success
    assert_select 'label', text: 'Supply items'
    assert_select 'div.value', text: 'Sand (15.0 kg)'


    put "/issues/#{issue.id}", params: {
      issue: {
        issue_supply_items_attributes: [
          { "quantity" => "0", "id" => issue_supply_item.id }
        ]
      }
    }

    refute IssueSupplyItem.any?

    follow_redirect!
    assert_response :success
    assert_select 'label', text: 'Supply items', count: 1
    assert_select 'div.value', text: /Sand/, count: 0

  end

  def test_used_supply_item_cannot_be_deleted
    Role.find(1).add_permission! :manage_issue_supply_items
    Role.find(1).add_permission! :manage_supply_items
    log_user 'jsmith', 'jsmith'

    sand = SupplyItem.generate! name: 'Sand', project: @project, unit: 'kg'

    get '/projects/ecookbook/issues/new'
    assert_response :success

    post '/projects/ecookbook/issues', params: {
      issue: {
        subject: 'test',
        issue_supply_items_attributes: [
          {"quantity"=>"10.5", "supply_item_id"=>sand.id.to_s}
        ]
      }
    }

    sand.reload
    assert_equal 1, sand.issue_supply_items.count
    assert issue_supply_item = sand.issue_supply_items.first
    assert_equal 10.5, issue_supply_item.quantity
    assert issue = issue_supply_item.issue
    assert_equal 'test', issue.subject

    follow_redirect!
    assert_response :success
    assert_select 'label', text: 'Supply items'
    assert_select 'div.value', text: 'Sand (10.5 kg)'

    assert_no_difference 'SupplyItem.count' do
      delete "/projects/ecookbook/supply_items/#{sand.id}"
    end
    assert_redirected_to '/projects/ecookbook/supply_items'
    assert_not_nil flash[:error]

    assert_difference 'Issue.count', -1 do
      delete "/issues/#{issue.id}"
    end
    assert_difference 'SupplyItem.count', -1 do
      delete "/projects/ecookbook/supply_items/#{sand.id}"
    end
    assert_redirected_to '/projects/ecookbook/supply_items'
    assert_nil flash[:error]
  end
end
