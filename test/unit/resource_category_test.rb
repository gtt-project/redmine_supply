require_relative '../test_helper'

class ResourceCategoryTest < ActiveSupport::TestCase

  fixtures :projects

  setup do
    @project = Project.find 'ecookbook'
  end

  test "should require at least one usage flag" do
    c = ResourceCategory.new name: 'some cat'
    refute c.valid?
    assert e = c.errors
    assert error = e[:base].first
    assert_match /please choose/i, error
  end

  test "should not allow flag deselection when in use" do
    cat = ResourceCategory.generate! project: @project
    Asset = Asset.generate! category: cat, project: @project

    cat.for_assets = false
    cat.for_humans = true
    refute cat.valid?
    assert e = cat.errors
    assert error = e[:for_assets].first
    assert_match /being used for assets/i, error
  end
end




