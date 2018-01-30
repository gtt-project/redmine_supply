module RedmineSupply
  class ViewHooks < Redmine::Hook::ViewListener

    render_on :view_layouts_base_html_head, inline: <<-END
        <%= stylesheet_link_tag 'supply', plugin: 'redmine_supply' %>
    END

    render_on :view_issues_show_details_bottom,
      partial: "hooks/issue_supply_items"
    render_on :view_issues_form_details_bottom,
      partial: "hooks/issue_supply_items_form"

  end
end

