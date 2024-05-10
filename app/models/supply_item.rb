# frozen_string_literal: true

class SupplyItem < (defined?(ApplicationRecord) == 'constant' ? ApplicationRecord : ActiveRecord::Base)
  belongs_to :project
  has_many :issue_supply_items
  has_many :issues, through: :issue_supply_items

  has_many :journals, class_name: 'SupplyItemJournal', dependent: :delete_all

  validates :project, presence: true
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false,
                                 scope: :project_id }
  validates :stock, presence: true, numericality: true

  scope :sorted, ->{ order name: :asc}

  acts_as_customizable

  # Overrides Redmine::Acts::Customizable::InstanceMethods#available_custom_fields
  # copied from issue.rb
  def available_custom_fields
    project&.all_supply_item_custom_fields || []
  end

  # Overrides
  # Redmine::Acts::Customizable::InstanceMethods#visible_custom_field_values
  # copied from issue.rb
  def visible_custom_field_values(user=nil)
    user_real = user || User.current
    custom_field_values.select do |value|
      value.custom_field.visible_by?(project, user_real)
    end
  end

  scope :like, ->(q){
    if q.present?
      pattern = "%#{q.downcase}%"
      sql = %w(name description).map {|column| "LOWER(#{table_name}.#{column}) LIKE :p"}.join(" OR ")
      where(sql, p: pattern)
    else
      all
    end
  }

  def stock_text(amount = self.stock)
    "#{amount} #{unit_name}"
  end

  def unit_name
    return @unit_name if @unit_name

    if cf = RedmineSupply.unit_cf
      @unit_name = custom_field_value cf
    end
  end

end
