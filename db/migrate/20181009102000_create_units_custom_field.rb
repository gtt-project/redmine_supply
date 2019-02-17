class CreateUnitsCustomField < ActiveRecord::Migration[5.2]
  def up
    unless RedmineSupply.unit_cf.present?
      SupplyItemCustomField.create! name: 'Unit',
        field_format: 'list',
        is_for_all: true,
        multiple: false,
        possible_values: "kg\nm\nm³"
    end
  end
end
