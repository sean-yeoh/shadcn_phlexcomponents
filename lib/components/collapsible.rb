# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Collapsible < Base
    def initialize(open: false, aria_id: "collapsible-#{SecureRandom.hex(5)}", **attributes)
      @open = open
      @aria_id = aria_id
      super(**attributes)
    end

    def trigger(**attributes, &)
      CollapsibleTrigger(open: @open, aria_id: @aria_id, **attributes, &)
    end

    def content(**attributes, &)
      CollapsibleContent(aria_id: @aria_id, **attributes, &)
    end

    def default_attributes
      {
        data: {
          controller: "shadcn-phlexcomponents--collapsible",
        },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
