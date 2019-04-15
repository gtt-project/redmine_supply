require_relative '../test_helper'

class HooksTest < ActiveSupport::TestCase
  fixtures :projects, :issues

  setup do
    @project = Project.find 1
    @issue = @project.issues.first

    @item = SupplyItem.generate! project: @project
    @isi = IssueSupplyItem.create! issue: @issue, supply_item: @item, quantity: 1

    @resource = Asset.generate! project: @project
    @iri = IssueResourceItem.create! issue: @issue, resource_item: @resource
  end

  test 'should add supply and resource items to json' do
    json = { foo: 'bar' }
    RedmineSupply::Hooks.instance.redmine_gtt_print_issue_to_json(issue: @issue,
                                                                  json: json)
    assert items = json[:attributes][:supply_items].split('\r\n')
    assert_equal 1, items.size
    assert_equal "#{@item.name} (1.0 pcs)", items.first

    assert items = json[:attributes][:resource_items].split('\r\n')
    assert_equal 1, items.size
    assert_equal @resource.name, items.first

  end
end


