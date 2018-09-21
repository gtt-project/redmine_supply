module RedmineResourceManager
  module IssuePatch
    def self.apply
      unless Issue < self
        Issue.prepend self

        Issue.class_eval do

          has_many :issue_resource_items
          has_many :resource_items, through: :issue_resource_items

          accepts_nested_attributes_for :issue_resource_items, allow_destroy: true

          safe_attributes 'issue_resource_items_attributes',
            if: ->(issue, user){ user.allowed_to?(:manage_issue_resources,
                                                  issue.project) }

        end

      end
    end

  end
end

