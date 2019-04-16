require_relative '../test_helper'

class ResourceCategoriesTest < Redmine::IntegrationTest
  fixtures :users, :email_addresses, :user_preferences,
    :roles, :projects, :members, :member_roles

  def setup
    super
    User.current = nil
    EnabledModule.delete_all

    @project = Project.find 'ecookbook'
    @project.enabled_modules.create! name: 'issue_tracking'
    @project.enabled_modules.create! name: 'supply'
  end

  def test_resource_categories_require_permission
    log_user 'jsmith', 'jsmith'

    get '/projects/ecookbook/settings'
    assert_response :success
    assert_select 'li a', text: 'Resource categories', count: 0
    post '/projects/ecookbook/resource_categories', params: { resource_category: { name: 'new', for_assets: '1' }}
    assert_response 403
  end

  def test_resource_category_crud
    Role.find(1).add_permission! :manage_resource_categories

    log_user 'jsmith', 'jsmith'

    get '/projects/ecookbook/settings'
    assert_select 'li a', text: 'Resource categories'

    get '/projects/ecookbook/settings/resource_categories'
    assert_response :success

    get '/projects/ecookbook/resource_categories/new'
    assert_response :success

    assert_difference 'ResourceCategory.count' do
      post '/projects/ecookbook/resource_categories', params: { resource_category: { name: 'Car', for_assets: '1' }}
    end
    assert_redirected_to '/projects/ecookbook/settings/resource_categories'

    follow_redirect!

    assert i = ResourceCategory.find_by_name('Car')
    assert_equal 'ecookbook', i.project.identifier

    get "/projects/ecookbook/resource_categories/#{i.id}/edit"
    assert_response :success

    patch "/projects/ecookbook/resource_categories/#{i.id}", params: { resource_category: { name: 'New Name' } }
    assert_redirected_to '/projects/ecookbook/settings/resource_categories'
    i.reload
    assert_equal 'New Name', i.name

    assert_difference 'ResourceCategory.count', -1 do
      delete "/projects/ecookbook/resource_categories/#{i.id}"
    end
    assert_redirected_to '/projects/ecookbook/settings/resource_categories'
  end
end


