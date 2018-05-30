require_relative '../test_helper'

class UnitTest < ActiveSupport::TestCase

  test 'should have units' do
    assert units = RedmineSupply::Unit.all
    assert_equal 1, units[:piece]
    assert_equal 2, units[:kg]
  end
end

