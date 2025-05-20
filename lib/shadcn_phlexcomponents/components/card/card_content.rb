# frozen_string_literal: true

module ShadcnPhlexcomponents
  class CardContent < Base
    STYLES = "p-6 pt-0"

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
