module RedmineSupply
  module ProjectPatch
    def self.apply
      Project.class_eval do
        has_many :supply_items, dependent: :destroy
      end
    end
  end
end

