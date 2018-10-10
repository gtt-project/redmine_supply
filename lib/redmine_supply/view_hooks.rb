module RedmineSupply
  class ViewHooks < Redmine::Hook::ViewListener
    include IssuesHelper

    render_on :view_layouts_base_html_head, inline: <<-END
        <%= stylesheet_link_tag 'supply', plugin: 'redmine_supply' %>
        <%= javascript_include_tag 'supply', plugin: 'redmine_supply' %>
    END

    def view_issues_show_details_bottom(context)
      return unless issue = context[:issue]

      issue_fields_rows do |rows|
        if User.current.allowed_to?(:view_issue_supply_items, issue.project) &&
            issue.issue_supply_items.any?

          rows.left l(:label_supply_item_plural),
            safe_join(RedmineSupply::IssueSupplyItemsPresenter.new(
              issue.issue_supply_items
            ).call, '<br />'.html_safe)
        end

        if User.current.allowed_to?(:view_issue_resources, issue.project) &&
            issue.issue_resource_items.any?

          rows.right l(:label_resource_item_plural),
            safe_join(RedmineSupply::ResourceItemsPresenter.(issue.resource_items),
                      '<br />'.html_safe)
        end

      end
    end

    render_on :view_issues_form_details_bottom,
      partial: "hooks/issues_form_details_bottom"

    render_on :view_custom_fields_form_supply_item_custom_field,
      partial: "hooks/supply_item_custom_field_form"

  end
end

