# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SidebarHeader < Base
    STYLES = "flex flex-col gap-2 p-2".freeze

    def view_template(&)
      div(**@attributes, &)
    end
  end
end