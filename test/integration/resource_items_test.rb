require_relative '../test_helper'

class ResourceItemsTest < Redmine::IntegrationTest
  fixtures :users, :email_addresses, :user_preferences,
    :roles, :projects, :members, :member_roles

  def setup
    super
    User.current = nil
    EnabledModule.delete_all

    @project = Project.find 'ecookbook'
    @project.enabled_modules.create! name: 'issue_tracking'
    @project.enabled_modules.create! name: 'supply'

    @cat = @project.resource_categories.create! name: 'Car'
  end

  def test_resource_items_require_permission
    log_user 'jsmith', 'jsmith'

    get '/projects/ecookbook/resource_items'
    assert_response 403

    post '/projects/ecookbook/resource_items', params: { resource_item: { name: 'new' }}
    assert_response 403
  end

  def test_resource_crud
    Role.find(1).add_permission! :manage_resource_items
    log_user 'jsmith', 'jsmith'

    get '/projects/ecookbook/resource_items'
    assert_response :success

    get '/projects/ecookbook/resource_items/new'
    assert_response :success

    assert_difference '@project.resource_items.count' do
      post '/projects/ecookbook/resource_items', params: { resource_item: { name: 'test', category_id: @cat.id}}
    end
    assert_redirected_to '/projects/ecookbook/resource_items'

    follow_redirect!

    assert i = ResourceItem.find_by_name('test')
    assert_equal @cat, i.category

    get "/projects/ecookbook/resource_items/#{i.id}/edit"
    assert_response :success

    patch "/projects/ecookbook/resource_items/#{i.id}", params: { resource_item: { name: 'new name' } }
    i.reload
    assert_equal 'new name', i.name

    assert_difference 'ResourceItem.count', -1 do
      delete "/projects/ecookbook/resource_items/#{i.id}"
    end
    assert_redirected_to '/projects/ecookbook/resource_items'

  end

  def test_autocomplete
    @cat.resource_items.create! name: 'some item'

    log_user 'jsmith', 'jsmith'

    get '/projects/ecookbook/resource_items/autocomplete', params: { q: 'so'}, xhr: true
    assert_response 403

    Role.find(1).add_permission! :manage_issue_resources
    get '/projects/ecookbook/resource_items/autocomplete', params: { q: 'so'}, xhr: true
    assert_response :success
    assert_select 'label', text: 'some item'
  end
end

