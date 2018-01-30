module RedmineSupply
  module IssuePatch
    def self.apply
      unless Issue < self
        Issue.prepend self

        Issue.class_eval do

          has_many :issue_supply_items

          accepts_nested_attributes_for :issue_supply_items

          safe_attributes 'issue_supply_items_attributes',
            if: ->(issue, user){ issue.new_record? &&
                                 user.allowed_to?(:manage_issue_supply_items,
                                                  issue.project) }


        end

      end
    end

  end
end
