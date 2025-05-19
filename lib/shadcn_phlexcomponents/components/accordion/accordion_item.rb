# frozen_string_literal: true

module ShadcnPhlexcomponents
  class AccordionItem < Base
    STYLES = "border-b"

    def initialize(value:, **attributes)
      @value = value
      super(**attributes)
    end

    def default_attributes
      {
        data: {
          state: "closed",
          value: @value,
          "accordion-target": "item",
        },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
