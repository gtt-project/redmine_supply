require_relative '../test_helper'

class SaveSupplyItemTest < ActiveSupport::TestCase
  self.use_transactional_fixtures = false

  fixtures :projects

  setup do
    @project = Project.find 'ecookbook'
  end

  teardown do
    SupplyItemJournal.delete_all
    SupplyItem.delete_all
  end

  test 'should require name' do
    r = RedmineSupply::SaveSupplyItem.(
      {name: '', stock: 5}, project: @project
    )
    refute r.supply_item_saved?, r.inspect
    assert i = r.supply_item
    refute i.persisted?
    assert r.error.present?
  end

  test 'should record stock change when created' do
    r = RedmineSupply::SaveSupplyItem.(
      {name: 'new item', stock: 5}, project: @project
    )
    assert r.supply_item_saved?, r.inspect
    assert i = r.supply_item
    assert_equal 5, i.stock

    assert j = i.journals.last
    assert_equal 5, j.change
  end

  test 'should record stock change when changed' do
    i = RedmineSupply::SaveSupplyItem.(
      {name: 'Sand', stock: 5}, project: @project
    ).supply_item

    r = nil
    assert_difference 'SupplyItemJournal.count' do
      r = RedmineSupply::SaveSupplyItem.(
        { stock: 15 }, supply_item: i
      )
    end

    assert r.supply_item_saved?, r.inspect
    i.reload
    assert_equal 15, i.stock

    assert j = i.journals.order(created_at: :desc).first
    assert j.is_a?(SupplyItemUpdate)
    assert_equal 10, j.change
  end

  test 'should not record anything if count did not change' do
    i = nil
    assert_difference 'SupplyItemJournal.count' do
      i = RedmineSupply::SaveSupplyItem.(
        {name: 'Sand', stock: 0}, project: @project
      ).supply_item
    end

    assert_no_difference 'SupplyItemJournal.count' do
      RedmineSupply::SaveSupplyItem.( { name: 'Kies' }, supply_item: i )
    end
  end
end


