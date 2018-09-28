require_relative '../../../test/test_helper'

SupplyItem.class_eval do
  def self.generate!(name: 'supply item', stock: 5, project:)
    RedmineSupply::SaveSupplyItem.(
      { name: name, stock: stock },
      project: project
    ).supply_item
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
