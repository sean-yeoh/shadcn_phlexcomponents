# frozen_string_literal: true

module ShadcnPhlexcomponents
  class AccordionContent < Base
    STYLES = "pb-4 pt-0"

    def initialize(aria_id: :nil, **attributes)
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      div(class: "overflow-hidden text-sm data-[state=closed]:animate-accordion-up
                  data-[state=open]:animate-accordion-down hidden",
          id: "#{@aria_id}-content",
          role: "region",
          aria: {
            labelledby: "#{@aria_id}-trigger"
          },
          data: {
            state: "closed",
            "shadcn-phlexcomponents--accordion-target": "content"
          }) do
        div(**@attributes, &)
      end
    end
  end
end
