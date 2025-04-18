# frozen_string_literal: true

module ShadcnPhlexcomponents
  class TableCaption < Base
    STYLES = "mt-4 text-sm text-muted-foreground".freeze

    def view_template(&)
      caption(**@attributes, &)
    end
  end
end