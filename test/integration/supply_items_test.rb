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
    @user = User.find_by_login 'jsmith'
    @unit = SupplyItemCustomField.generate_unit_field!
  end

  def test_supply_items_require_permission
    log_user 'jsmith', 'jsmith'

    get '/projects/ecookbook'
    assert_response :success
    assert_select 'li a', text: 'Supply items', count: 0
    post '/projects/ecookbook/supply_items', params: { supply_item: { name: 'new' }}
    assert_response 403
  end

  def test_supply_item_stock_change
    Role.find(1).add_permission! :manage_supply_items
    Role.find(1).add_permission! :view_supply_items

    log_user 'jsmith', 'jsmith'

    i = SupplyItem.generate! stock: 1.5, project: @project

    xhr :get, "/projects/ecookbook/supply_items/#{i.id}/stock"
    assert_response :success

    xhr :patch, "/projects/ecookbook/supply_items/#{i.id}/stock", supply_item_stock_update: { stock_change: '1.2', comment: 'neuzugang' }
    assert_response :success

    i.reload
    assert_equal 2.7, i.stock
    get "/projects/ecookbook/supply_items/#{i.id}/edit"
    assert_response :success
    assert_select 'table.supply_item_journals td', 'neuzugang'
  end

  def test_supply_item_crud
    Role.find(1).add_permission! :manage_supply_items
    Role.find(1).add_permission! :view_supply_items

    log_user 'jsmith', 'jsmith'

    get '/projects/ecookbook'
    assert_select '#main-menu li a', text: 'Supply items'

    get '/projects/ecookbook/supply_items'
    assert_response :success

    get '/projects/ecookbook/supply_items/new'
    assert_response :success
    assert_select 'input[id=supply_item_stock]', count: 1


    assert_difference 'SupplyItem.count' do
      post '/projects/ecookbook/supply_items', params: { supply_item: { name: 'test', description: 'lorem ipsum', stock: '2.3', custom_field_values: {@unit.id.to_s => 'm'}}}
    end
    assert_redirected_to '/projects/ecookbook/supply_items'

    follow_redirect!

    assert i = SupplyItem.find_by_name('test')
    assert_equal 'lorem ipsum', i.description
    assert_equal 'ecookbook', i.project.identifier
    assert_equal 2.3, i.stock

    get "/projects/ecookbook/supply_items/#{i.id}/edit"
    assert_response :success
    assert_select 'input[id=supply_item_stock]', count: 0

    patch "/projects/ecookbook/supply_items/#{i.id}", params: { supply_item: { name: 'new', stock: 10 } }
    i.reload
    assert_equal 'lorem ipsum', i.description
    assert_equal 'new', i.name
    # no direct stock update
    assert_equal 2.3, i.stock

    assert_difference 'SupplyItem.count', -1 do
      delete "/projects/ecookbook/supply_items/#{i.id}"
    end
    assert_redirected_to '/projects/ecookbook/supply_items'

  end
end

