# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SidebarContent < Base
    STYLES = "flex min-h-0 flex-1 flex-col gap-2 overflow-auto"

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
