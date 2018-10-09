module RedmineSupply
  module ProjectPatch
    def self.apply
      unless Project < self
        Project.class_eval do
          prepend RedmineSupply::ProjectPatch
          has_many :supply_items, dependent: :destroy
        end
      end
    end

    def all_supply_item_custom_fields
      if new_record?
        @all_supply_item_custom_fields ||= SupplyItemCustomField.
          sorted.
          where("is_for_all = ? OR id IN (?)", true, supply_item_custom_field_ids)
      else
        @all_supply_item_custom_fields ||= SupplyItemCustomField.
          sorted.
          where("is_for_all = ? OR id IN (SELECT DISTINCT cfp.custom_field_id" +
            " FROM #{table_name_prefix}custom_fields_projects#{table_name_suffix} cfp" +
            " WHERE cfp.project_id = ?)", true, id)
      end
    end
  end
end

