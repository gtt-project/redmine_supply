module RedmineResourceManager
  module ProjectPatch
    def self.apply
      Project.class_eval do
        has_many :resource_categories
        has_many :resource_items, through: :resource_categories
      end
    end

    module InstanceMethods

    end
  end
end
