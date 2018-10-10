module RedmineResourceManager
  class ViewHooks < Redmine::Hook::ViewListener

    render_on :view_layouts_base_html_head, inline: <<-END
        <%= stylesheet_link_tag 'resource_manager', plugin: 'redmine_resource_manager' %>
        <%= javascript_include_tag 'resource_manager', plugin: 'redmine_resource_manager' %>
    END

    render_on :view_issues_show_details_bottom,
      partial: "hooks/issue_resource_items"

  end
end


