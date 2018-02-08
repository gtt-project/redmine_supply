require_relative '../test_helper'

class SupplyItemsTest < Redmine::IntegrationTest
  fixtures :users, :email_addresses, :user_preferences,
    :roles, :projects, :members, :member_roles

  def setup
    super
    User.current = nil
    @project = Project.find 'ecookbook'
    EnabledModule.delete_all
    EnabledModule.create! project: @project, name: 'supply'
  end

  def test_supply_items_require_permission
    log_user 'jsmith', 'jsmith'

    get '/projects/ecookbook/settings'
    assert_response :success
    assert_select 'li a', text: 'Supply items', count: 0
    post '/projects/ecookbook/supply_items', params: { supply_item: { name: 'new' }}
    assert_response 403
  end

  def test_supply_item_crud
    Role.find(1).add_permission! :manage_supply_items

    log_user 'jsmith', 'jsmith'

    get '/projects/ecookbook/settings'
    assert_select 'li a', text: 'Supply items'

    get '/projects/ecookbook/settings/supply_items'
    assert_response :success

    get '/projects/ecookbook/supply_items/new'
    assert_response :success

    assert_difference 'SupplyItem.count' do
      post '/projects/ecookbook/supply_items', params: { supply_item: { name: 'test', description: 'lorem ipsum'}}
    end
    assert_redirected_to '/projects/ecookbook/settings/supply_items'

    follow_redirect!

    assert i = SupplyItem.find_by_name('test')
    assert_equal 'lorem ipsum', i.description
    assert_equal 'ecookbook', i.project.identifier

    get "/projects/ecookbook/supply_items/#{i.id}/edit"
    assert_response :success

    patch "/projects/ecookbook/supply_items/#{i.id}", params: { supply_item: { name: 'new' } }
    i.reload
    assert_equal 'lorem ipsum', i.description
    assert_equal 'new', i.name

    assert_difference 'SupplyItem.count', -1 do
      delete "/projects/ecookbook/supply_items/#{i.id}"
    end
    assert_redirected_to '/projects/ecookbook/settings/supply_items'
  end
end

