# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SidebarContainer < Base
    STYLES = "group/sidebar-wrapper text-sidebar-foreground has-[[data-variant=inset]]:bg-sidebar flex min-h-svh w-full"

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
