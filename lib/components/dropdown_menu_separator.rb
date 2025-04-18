# frozen_string_literal: true
module ShadcnPhlexcomponents

  class DropdownMenuSeparator < Base
    STYLES = "-mx-1 my-1 h-px bg-muted".freeze

    def view_template(&)
      div(**@attributes, &)
    end

    def default_attributes
      {
        role: "separator",
        aria: {
          orientation: "horizontal"
        }
      }
    end
  end
end