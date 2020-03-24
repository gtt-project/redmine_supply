module RedmineResourceManager
  module IssuePatch
    def self.apply
      unless Issue < self
        Issue.prepend self

        Issue.class_eval do

          has_many :issue_resource_items, dependent: :destroy
          has_many :resource_items, through: :issue_resource_items

          accepts_nested_attributes_for :issue_resource_items, allow_destroy: true

          safe_attributes 'issue_resource_items_attributes',
            if: ->(issue, user){ user.allowed_to?(:manage_issue_resources,
                                                  issue.project) }

        end
      end
    end


    def issue_human_resource_item_names
      cached_items = instance_variable_get("@issue_human_resource_items")
      if !cached_items.nil?
        IssueResourceItemsPresenter.new(cached_items).to_s
      else
        IssueResourceItemsPresenter.new(issue_human_resource_items).to_s
      end
    end
    def issue_asset_resource_item_names
      cached_items = instance_variable_get("@issue_asset_resource_items")
      if !cached_items.nil?
        IssueResourceItemsPresenter.new(cached_items).to_s
      else
        IssueResourceItemsPresenter.new(issue_asset_resource_items).to_s
      end
    end

    def issue_human_resource_items
      issue_resource_items.includes(:resource_item)
        .where(resource_items: { type: 'Human'})
    end

    def issue_asset_resource_items
      issue_resource_items.includes(:resource_item)
        .where(resource_items: { type: 'Asset'})
    end

    def resource_items_by_type
      {
        'asset' => resource_items.where(type: 'Asset'),
        'human' => resource_items.where(type: 'Human')
      }
    end

  end
end

