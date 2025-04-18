# frozen_string_literal: true

module ShadcnPhlexcomponents
  class CardTitle < Base
    STYLES = "font-semibold leading-none tracking-tight"

    def view_template(&)
      div(**@attributes, &)
    end
  end
end