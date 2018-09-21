class ResourceCategory < ActiveRecord::Base
  belongs_to :project
  has_many :resource_items, foreign_key: :category_id

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false, scope: :project_id }

  scope :sorted, ->{ order name: :asc}
end
