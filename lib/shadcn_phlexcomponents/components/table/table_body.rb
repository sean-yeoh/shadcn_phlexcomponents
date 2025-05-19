# frozen_string_literal: true

module ShadcnPhlexcomponents
  class TableBody < Base
    STYLES = "[&_tr:last-child]:border-0"

    def view_template(&)
      tbody(**@attributes, &)
    end
  end
end
