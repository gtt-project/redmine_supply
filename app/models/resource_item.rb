class ResourceItem < ActiveRecord::Base
  belongs_to :project
  belongs_to :category, class_name: 'ResourceCategory'

  has_many :issue_resource_items

  validates :project_id, presence: true
  #validates :category_id, presence: true
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false, scope: [:project_id, :category_id] }

  validates :start_date, :date => true
  validates :end_date, :date => true

  scope :sorted, ->{ order name: :asc}
  scope :humans, ->{ where type: 'Human' }
  scope :assets, ->{ where type: 'Asset' }
  scope :filter_by_date, ->(date = Date.today){
    where("(start_date is NULL or start_date <= :date) AND (end_date is NULL or :date <= end_date)", date: date)
  }

  scope :like, ->(q){
    if q.present?
      where("LOWER(#{table_name}.name) LIKE :p", p: "%#{q.downcase}%")
    else
      all
    end
  }
end

