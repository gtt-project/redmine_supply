module RedmineSupply
  class ViewHooks < Redmine::Hook::ViewListener

    render_on :view_layouts_base_html_head, inline: <<-END
        <%= stylesheet_link_tag 'supply', plugin: 'redmine_supply' %>
    END
  end
end

