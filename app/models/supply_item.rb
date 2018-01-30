class SupplyItem < ActiveRecord::Base
  belongs_to :project

  validates :project, presence: true
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false,
                                 scope: :project_id }

  enum unit: {
    piece: 1,
    kg: 2,
  }
end
