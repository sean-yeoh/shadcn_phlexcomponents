# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SidebarGroup < Base
    STYLES = "relative flex w-full min-w-0 flex-col p-2"

    def view_template(&)
      div(**@attributes, &)
    end
  end
end