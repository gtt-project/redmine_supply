class ResourceItem < ActiveRecord::Base
  belongs_to :category, class_name: 'ResourceCategory'
  has_many :issue_resource_items

  validates :category_id, presence: true
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false, scope: :category_id }

  scope :sorted, ->{ order name: :asc}

  scope :like, ->(q){
    if q.present?
      where("LOWER(#{table_name}.name) LIKE :p", p: "%#{q.downcase}%")
    else
      all
    end
  }
end

