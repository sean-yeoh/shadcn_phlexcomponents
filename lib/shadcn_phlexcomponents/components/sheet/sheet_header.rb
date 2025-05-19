# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SheetHeader < Base
    STYLES = "flex flex-col space-y-2 text-center sm:text-left"

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
