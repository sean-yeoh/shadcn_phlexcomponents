# frozen_string_literal: true

module ShadcnPhlexcomponents
  class TableRow < Base
    STYLES = "border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted".freeze

    def view_template(&)
      tr(**@attributes, &)
    end
  end
end