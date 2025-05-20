# frozen_string_literal: true

module ShadcnPhlexcomponents
  class TableFooter < Base
    STYLES = "border-t bg-muted/50 font-medium [&>tr]:last:border-b-0"

    def view_template(&)
      tfoot(**@attributes, &)
    end
  end
end
