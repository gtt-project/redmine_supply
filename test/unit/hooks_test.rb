require_relative '../test_helper'

class HooksTest < ActiveSupport::TestCase
  fixtures :projects, :issues

  setup do
    @project = Project.find 1
    @issue = @project.issues.first

    @item = SupplyItem.generate! project: @project
    @isi = IssueSupplyItem.create! issue: @issue, supply_item: @item, quantity: 1

    @asset_resource = Asset.generate! project: @project
    @iari = IssueResourceItem.create! issue: @issue, resource_item: @asset_resource

    @human_resource = Human.generate! project: @project
    @ihri = IssueResourceItem.create! issue: @issue, resource_item: @human_resource
  end

  test 'should add supply and resource items to json' do
    json = { foo: 'bar' }
    RedmineSupply::Hooks.instance.redmine_gtt_print_issue_to_json(issue: @issue,
                                                                  json: json)
    assert items = json[:attributes][:supply_items].split('\r\n')
    assert_equal 1, items.size
    assert_equal "#{@item.name} (1.0 pcs)", items.first

    assert items = json[:attributes][:asset_resource_items].split('\r\n')
    assert_equal 1, items.size
    assert_equal @asset_resource.name, items.first

    assert items = json[:attributes][:human_resource_items].split('\r\n')
    assert_equal 1, items.size
    assert_equal @human_resource.name, items.first

  end
end


