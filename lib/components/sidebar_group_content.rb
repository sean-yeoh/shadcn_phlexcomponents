# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SidebarGroupContent < Base
    STYLES = "w-full text-sm"

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
