require_relative '../test_helper'

class IssueSupplyItemChangeTest < ActiveSupport::TestCase

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
           :enumerations

  setup do
    @project = Project.find 'ecookbook'
    @issue = @project.issues.open.first
  end

  teardown do
  end

  test 'should record stock change when saved or destroyed' do
    r = RedmineSupply::SaveSupplyItem.(
      {name: 'new item', stock: 5}, project: @project
    )
    assert i = r.supply_item

    isi = nil
    assert_difference 'IssueSupplyItemChange.count' do
      isi = IssueSupplyItem.create! issue: @issue, supply_item: i, quantity: 1.5
    end
    assert_equal 1.5, isi.quantity

    i.reload
    assert_equal 3.5, i.stock

    c = IssueSupplyItemChange.last
    assert_equal @issue, c.issue
    assert_equal i, c.supply_item
    assert_equal 5, c.old_stock
    assert_equal 3.5, c.new_stock

    assert_difference 'IssueSupplyItemChange.count' do
      isi.update_attribute :quantity, 2
    end

    i.reload
    assert_equal 3, i.stock

    c = IssueSupplyItemChange.last
    assert_equal @issue, c.issue
    assert_equal i, c.supply_item
    assert_equal 3.5, c.old_stock
    assert_equal 3, c.new_stock


    assert_difference 'IssueSupplyItemChange.count' do
      isi.destroy
    end

    i.reload
    assert_equal 5, i.stock

    c = IssueSupplyItemChange.last
    assert_equal @issue, c.issue
    assert_equal i, c.supply_item
    assert_equal 3, c.old_stock
    assert_equal 5, c.new_stock
  end

end



