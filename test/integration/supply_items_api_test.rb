require_relative '../test_helper'

class SupplyItemsApiTest < Redmine::ApiTest::Base
  fixtures :projects, :users,
           :roles, :member_roles, :members

  setup do
    @project = Project.find 'ecookbook'
    EnabledModule.create! name: 'supply', project: @project
    @item = SupplyItem.generate! project: @project
    @unit = SupplyItemCustomField.generate_unit_field!
    Role.find(1).add_permission! :manage_supply_items
    Role.find(1).add_permission! :view_supply_items
  end

  test "GET /supply_items.xml should return items" do
    get '/projects/ecookbook/supply_items.xml', :headers => credentials('jsmith')
    assert_response :success
    assert_equal 'application/xml', @response.content_type
    assert_select 'supply_items[type=array] supply_item id', text: @item.id.to_s
  end

  test "GET /supply_items/:id.xml should return the item" do
    get "/projects/ecookbook/supply_items/#{@item.id}.xml", :headers => credentials('jsmith')
    assert_response :success
    assert_equal 'application/xml', @response.content_type
    assert_select 'supply_item id', :text => @item.id.to_s
    assert_select 'supply_item name', :text => @item.name.to_s
  end

  test "get on closed project should return the item" do
    @project.close
    @project.save!

    get "/projects/ecookbook/supply_items/#{@item.id}.xml", :headers => credentials('jsmith')
    assert_response :success
    assert_equal 'application/xml', @response.content_type
    assert_select 'supply_item id', :text => @item.id.to_s
    assert_select 'supply_item name', :text => @item.name.to_s
  end

  test "post should create item" do
    assert_difference 'SupplyItem.count' do
      post '/projects/ecookbook/supply_items.xml',
        params: {supply_item: {name: 'test', stock: '3', custom_field_values: {@unit.id => 'kg'}}},
        headers: credentials('jsmith')
    end
    assert_response :created
    assert_equal 'application/xml', @response.content_type

    item = SupplyItem.order(:created_at).last
    assert_equal @project, item.project
    assert_equal 'test', item.name
    assert_equal 3, item.stock
    assert_equal 'kg', item.unit_name
  end


  test "POST /supply_items.xml with invalid parameters should return errors" do
    assert_no_difference 'SupplyItem.count' do
      post '/projects/ecookbook/supply_items.xml',
        params: {supply_item: {name: 'test', stock: '3', custom_field_values: {@unit.id => ''}}},
        :headers => credentials('jsmith')
    end
    assert_response :unprocessable_entity
    assert_equal 'application/xml', @response.content_type

    assert_select 'errors error', :text => "Unit cannot be blank"
  end


  test "PUT /supply_items/:id.xml with valid parameters should update item" do
    assert_no_difference 'SupplyItem.count' do
      put "/projects/ecookbook/supply_items/#{@item.id}.xml",
        params: {supply_item: {name: 'new name', custom_field_values: {@unit.id => 'm'}}},
        :headers => credentials('jsmith')
    end
    assert_response :success
    assert_equal '', @response.body
    item = SupplyItem.find @item.id
    assert_equal 'new name', item.name
    assert_equal 'm', item.unit_name
  end

  test "PUT /time_entries/:id.xml with invalid parameters should return errors" do
    assert_no_difference 'SupplyItem.count' do
      put "/projects/ecookbook/supply_items/#{@item.id}.xml",
        params: {supply_item: {name: '', custom_field_values: {@unit.id => 'm'}}},
        :headers => credentials('jsmith')
    end
    assert_response :unprocessable_entity
    assert_equal 'application/xml', @response.content_type

    assert_select 'errors error', :text => "Name cannot be blank"
  end

  test "DELETE /supply_item/:id.xml should destroy item" do
    assert_difference 'SupplyItem.count', -1 do
      delete "/projects/ecookbook/supply_items/#{@item.id}.xml",
        :headers => credentials('jsmith')
    end
    assert_response :success
    assert_equal '', @response.body
    assert_nil SupplyItem.find_by_id(@item.id)
  end
end

