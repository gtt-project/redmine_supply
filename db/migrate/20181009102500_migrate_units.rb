class SupplyItem < ActiveRecord::Base

  class Unit
    def self.all
      Hash[
        YAML.load(IO.read(Rails.root.join "plugins/redmine_supply/config/units.yml"))["units"].map.with_index do |unit, idx|
          [unit.to_sym, idx + 1]
        end
      ]
    end
  end

  enum unit: Unit.all
end

class MigrateUnits < ActiveRecord::Migration[5.2]
  def up
    if cf = RedmineSupply.unit_cf
      SupplyItem.find_each do |i|
        if unit = i.unit.presence
          unless cf.possible_values.include? unit
            cf.possible_values << unit.dup
            cf.save
          end

          execute "insert into #{CustomValue.table_name}(customized_id, customized_type, custom_field_id, value) values(#{ActiveRecord::Base.connection.quote i.id}, 'SupplyItem', #{ActiveRecord::Base.connection.quote cf.id}, #{ActiveRecord::Base.connection.quote unit})"
        end
      end

      cf.update_column :is_required, true
    end
  end
end
