# frozen_string_literal: true

module ShadcnPhlexcomponents

  class DropdownMenuLabel < Base
    STYLES = "px-2 py-1.5 text-sm font-semibold".freeze

    def view_template(&)
      div(**@attributes, &)
    end
  end
end