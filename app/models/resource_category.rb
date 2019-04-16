class ResourceCategory < ActiveRecord::Base
  belongs_to :project
  has_many :resource_items, foreign_key: :category_id

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false, scope: :project_id }
  validate :check_usage_flags

  scope :sorted, ->{ order name: :asc}
  scope :for_humans, -> { where for_humans: true }
  scope :for_assets, -> { where for_assets: true }

  private

  def check_usage_flags
    if !for_assets? and !for_humans?
      errors.add :base, :select_category_usage
      return
    end

    unless new_record?
      if resource_items.humans.any? and !for_humans?
        errors.add :for_humans, :in_use
      end
      if resource_items.assets.any? and !for_assets?
        errors.add :for_assets, :in_use
      end
    end
  end
end
