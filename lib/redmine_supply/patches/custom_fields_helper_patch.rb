module RedmineSupply
  module Patches
    module CustomFieldsHelperPatch
      def self.apply
        unless CustomFieldsHelper::CUSTOM_FIELDS_TABS.detect{|t|
          t[:name] == 'SupplyItemCustomField'
        }
          CustomFieldsHelper::CUSTOM_FIELDS_TABS.push({
            name: 'SupplyItemCustomField',
            partial: 'custom_fields/index',
            label: :label_supply_item_plural
          })
        end
      end

    end
  end
end
