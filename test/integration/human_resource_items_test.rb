require_relative '../test_helper'

class HumanResourceItemsTest < Redmine::IntegrationTest
  fixtures :users, :email_addresses, :user_preferences,
    :roles, :projects, :members, :member_roles

  def setup
    super
    User.current = nil
    EnabledModule.delete_all

    @project = Project.find 'ecookbook'
    @project.enabled_modules.create! name: 'issue_tracking'
    @project.enabled_modules.create! name: 'resource'

    @cat = ResourceCategory.generate! project: @project
  end

  def test_human_resource_items_require_permission
    log_user 'jsmith', 'jsmith'

    get '/projects/ecookbook/human_resource_items'
    assert_response 403

    post '/projects/ecookbook/human_resource_items', params: { human: { name: 'new' }}
    assert_response 403
  end

  def test_resource_crud
    Role.find(1).add_permission! :manage_resource_items
    log_user 'jsmith', 'jsmith'

    get '/projects/ecookbook/human_resource_items'
    assert_response :success

    get '/projects/ecookbook/human_resource_items/new'
    assert_response :success

    assert_difference 'Human.count' do
      post '/projects/ecookbook/human_resource_items', params: { human: { name: 'test', category_id: @cat.id}}
    end
    assert_redirected_to '/projects/ecookbook/human_resource_items'

    follow_redirect!

    assert i = ResourceItem.find_by_name('test')
    assert_equal @cat, i.category

    get "/projects/ecookbook/human_resource_items/#{i.id}/edit"
    assert_response :success

    patch "/projects/ecookbook/human_resource_items/#{i.id}", params: { human: { name: 'new name' } }
    i.reload
    assert_equal 'new name', i.name

    assert_difference 'Human.count', -1 do
      delete "/projects/ecookbook/human_resource_items/#{i.id}"
    end
    assert_redirected_to '/projects/ecookbook/human_resource_items'

  end

  def test_autocomplete
    Asset.create! project: @project, name: 'some asset', category: @cat
    Human.create! project: @project, name: 'some human', category: @cat

    log_user 'jsmith', 'jsmith'

    get '/projects/ecookbook/resource_items/autocomplete', params: { q: 'so', type: 'Human'}, xhr: true
    assert_response 403

    Role.find(1).add_permission! :manage_issue_resources
    get '/projects/ecookbook/resource_items/autocomplete', params: { q: 'so', type: 'Human'}, xhr: true
    assert_response :success
    assert_select 'label', text: 'some human'
    assert_select 'label', text: 'some asset', count: 0
  end
end


