# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SidebarTrigger < Base
    STYLES = <<~HEREDOC
      inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md
      text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none
      focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none
      disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 hover:bg-accent
      hover:text-accent-foreground h-7 w-7 -ml-1 cursor-pointer
    HEREDOC

    def initialize(sidebar_id:, **attributes)
      @sidebar_id = sidebar_id
      super(**attributes)
    end

    def default_attributes
      {
        data: {
          sidebar_id: @sidebar_id,
          controller: "sidebar-trigger",
          action: "click->sidebar-trigger#toggle",
        },
      }
    end

    def view_template(&)
      button(**@attributes) do
        if block_given?
          yield
        else
          icon("panel-left", class: "")
        end

        span(class: "sr-only") { "Toggle Sidebar" }
      end
    end
  end
end
