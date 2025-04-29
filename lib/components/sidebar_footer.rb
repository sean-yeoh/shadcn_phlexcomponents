# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SidebarFooter < Base
    STYLES = "flex flex-col gap-2 p-2"

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
