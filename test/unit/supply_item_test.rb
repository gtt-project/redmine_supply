require_relative '../test_helper'

class SupplyItemTest < ActiveSupport::TestCase
  fixtures :projects

  setup do
    @project = Project.find 'ecookbook'
  end

  test 'should find items' do
    refute SupplyItem.like('te').any?
    refute SupplyItem.like('desc').any?

    RedmineSupply::SaveSupplyItem.({name: 'test'}, project: @project)
    assert SupplyItem.like('te').any?
    refute SupplyItem.like('desc').any?

    RedmineSupply::SaveSupplyItem.({name: 'another test', description: 'the description'}, project: @project)
    assert SupplyItem.like('desc').any?
  end

  test 'should require name' do
    r = RedmineSupply::SaveSupplyItem.({}, project: @project)
    refute r.supply_item_saved?
    assert r.supply_item.errors[:name]
  end

  test 'should require project' do
    r = RedmineSupply::SaveSupplyItem.({name: 'test'}, user: User.current)
    refute r.supply_item_saved?
    assert r.supply_item.errors[:project]
  end

  test 'should validate name uniqueness with project scope' do
    assert_difference 'SupplyItem.count' do
      r = RedmineSupply::SaveSupplyItem.({name: 'test'}, project: @project)
      assert r.supply_item_saved?
      assert_equal 'test', r.supply_item.name
    end

    assert_no_difference 'SupplyItem.count' do
      r = RedmineSupply::SaveSupplyItem.({name: 'Test'}, project: @project)
      refute r.supply_item_saved?
      assert r.supply_item.errors[:name]
    end

    project = Project.find 'onlinestore'
    assert_difference 'SupplyItem.count' do
      r = RedmineSupply::SaveSupplyItem.({name: 'Test'}, project: project)
      assert r.supply_item_saved?
      assert_equal 'Test', r.supply_item.name
      assert_equal project, r.supply_item.project
    end
  end

  test 'deletion of project should delete supply items' do
    RedmineSupply::SaveSupplyItem.({name: 'test'}, project: @project)
    assert_difference 'SupplyItem.count', -1 do
      @project.destroy
    end
  end
end

