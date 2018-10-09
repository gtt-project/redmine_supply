# frozen_string_literal: true

class SupplyItemCustomField < CustomField
  has_and_belongs_to_many :projects,
    join_table: "#{table_name_prefix}custom_fields_projects#{table_name_suffix}",
    foreign_key: "custom_field_id"

  has_many :supply_items, through: :supply_item_custom_values

  safe_attributes 'project_ids'

  def type_name
    :label_supply_item_plural
  end

  def visible_by?(project, user=User.current)
    super || (roles & user.roles_for_project(project)).present?
  end

  def visibility_by_project_condition(project_key=nil, user=User.current, id_column=nil)
    sql = super
    id_column ||= id
    project_condition = "EXISTS (SELECT 1 FROM #{CustomField.table_name} ifa WHERE ifa.is_for_all = #{self.class.connection.quoted_true} AND ifa.id = #{id_column})" +
      " OR #{Issue.table_name}.project_id IN (SELECT project_id FROM #{table_name_prefix}custom_fields_projects#{table_name_suffix} WHERE custom_field_id = #{id_column})"

    "((#{sql}) AND (#{project_condition}))"
  end

  def validate_custom_field
    super
    errors.add(:base, l(:label_role_plural) + ' ' + l('activerecord.errors.messages.blank')) unless visible? || roles.present?
  end
end
