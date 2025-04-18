# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SidebarMenuSub < Base
    STYLES = <<~HEREDOC
      border-sidebar-border mx-3.5 flex min-w-0 translate-x-px flex-col
      gap-1 border-l px-2.5 py-0.5 group-data-[collapsible=icon]:hidden  
    HEREDOC

    def view_template(&)
      ul(**@attributes, &)
    end
  end
end