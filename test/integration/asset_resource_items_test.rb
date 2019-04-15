require_relative '../test_helper'

class AssetResourceItemsTest < Redmine::IntegrationTest
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

  def test_asset_resource_items_require_permission
    log_user 'jsmith', 'jsmith'

    get '/projects/ecookbook/asset_resource_items'
    assert_response 403

    post '/projects/ecookbook/asset_resource_items', params: { asset: { name: 'new' }}
    assert_response 403
  end

  def test_resource_crud
    Role.find(1).add_permission! :manage_resource_items
    log_user 'jsmith', 'jsmith'

    get '/projects/ecookbook/asset_resource_items'
    assert_response :success

    get '/projects/ecookbook/asset_resource_items/new'
    assert_response :success

    assert_difference 'Asset.count' do
      post '/projects/ecookbook/asset_resource_items', params: { asset: { name: 'test', category_id: @cat.id}}
    end
    assert_redirected_to '/projects/ecookbook/asset_resource_items'

    follow_redirect!

    assert i = ResourceItem.find_by_name('test')
    assert_equal @cat, i.category

    get "/projects/ecookbook/asset_resource_items/#{i.id}/edit"
    assert_response :success

    patch "/projects/ecookbook/asset_resource_items/#{i.id}", params: { asset: { name: 'new name' } }
    i.reload
    assert_equal 'new name', i.name

    assert_difference 'Asset.count', -1 do
      delete "/projects/ecookbook/asset_resource_items/#{i.id}"
    end
    assert_redirected_to '/projects/ecookbook/asset_resource_items'

  end

  def test_autocomplete
    Asset.create! project: @project, category: @cat, name: 'some asset'
    Human.create! project: @project, category: @cat, name: 'some human'

    log_user 'jsmith', 'jsmith'

    get '/projects/ecookbook/resource_items/autocomplete', params: { q: 'so', type: 'Asset'}, xhr: true
    assert_response 403

    Role.find(1).add_permission! :manage_issue_resources
    get '/projects/ecookbook/resource_items/autocomplete', params: { q: 'so', type: 'Asset'}, xhr: true
    assert_response :success
    assert_select 'label', text: 'some asset'
    assert_select 'label', text: 'some human', count: 0
  end
end

