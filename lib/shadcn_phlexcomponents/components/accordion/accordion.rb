# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Accordion < Base
    def initialize(value: nil, multiple: false, aria_id: "accordion-#{SecureRandom.hex(5)}", **attributes)
      @multiple = multiple
      @value = value&.is_a?(String) ? [value] : value
      @aria_id = aria_id
      super(**attributes)
    end

    def item(**attributes, &)
      AccordionItem(**attributes, &)
    end

    def trigger(**attributes, &)
      AccordionTrigger(aria_id: @aria_id, **attributes, &)
    end

    def content(**attributes, &)
      AccordionContent(aria_id: @aria_id, **attributes, &)
    end

    def default_attributes
      {
        data: {
          value: (@value || []).to_json,
          multiple: @multiple.to_s,
          controller: "accordion",
        },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
