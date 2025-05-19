# frozen_string_literal: true

module ShadcnPhlexcomponents
  class CardDescription < Base
    STYLES = "text-sm text-muted-foreground"

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
