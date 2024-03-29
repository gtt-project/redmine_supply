require_relative '../test_helper'

class UpdateStockTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  fixtures :projects

  setup do
    @project = Project.find 'ecookbook'
  end

  teardown do
    SupplyItemJournal.delete_all
    SupplyItem.delete_all
  end

  test 'should record stock change' do
    s = RedmineSupply::SaveSupplyItem.(
      {name: 'new item', stock: 5}, project: @project
    ).supply_item

    u = SupplyItemStockUpdate.new stock_change: '0.5'
    r = RedmineSupply::UpdateStock.(u, supply_item: s)
    assert r.supply_item_saved?, r.inspect
    s.reload
    assert_equal 5.5, s.stock

    assert j = s.journals.last
    assert_equal 0.5, j.change


    u = SupplyItemStockUpdate.new stock_change: '-1.5', comment: 'schwund'
    r = RedmineSupply::UpdateStock.(u, supply_item: s)
    assert r.supply_item_saved?, r.inspect
    s.reload
    assert_equal 4, s.stock

    assert j = s.journals.last
    assert_equal(-1.5, j.change)
    assert_equal 'schwund', j.comment

  end

end



