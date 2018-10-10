require_relative '../../../test/test_helper'

SupplyItemCustomField.class_eval do
  def self.generate_unit_field!
    find_by_name('Unit') || create!(name: 'Unit',
                                    field_format: 'list',
                                    is_for_all: true,
                                    multiple: false,
                                    is_required: true,
                                    possible_values: "kg\nm\nm³\npcs")
  end
end

SupplyItem.class_eval do
  def self.generate!(name: 'supply item', unit: 'pcs', stock: 5, project:)
    unit_cf = SupplyItemCustomField.generate_unit_field!
    r = RedmineSupply::SaveSupplyItem.(
      { name: name, stock: stock, custom_field_values: { unit_cf.id => unit } },
      project: project
    )
    if r.error
      puts r.error.inspect
      fail "error saving supply item"
    else
      return r.supply_item
    end
  end
end

ResourceItem.class_eval do
  def self.generate!(name: 'resource item', project:,
                     category: ResourceCategory.generate!(project: project))
    r = RedmineResourceManager::SaveResourceItem.(
      { name: name, category_id: category.id }, project: project
    )
    if r.item_saved?
      r.item
    else
      puts r.item.inspect
    end
  end
end

ResourceCategory.class_eval do
  def self.generate!(name: "resource category", project:)
    r = RedmineResourceManager::SaveResourceCategory.(
      { name: name }, project: project
    )
    if r.category_saved?
      r.category
    else
      puts r.category.inspect
    end
  end
end
