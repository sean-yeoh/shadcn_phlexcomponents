# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Popover < Base
    STYLES = "inline-block max-w-fit"

    def initialize(side: :bottom, aria_id: "popover-#{SecureRandom.hex(5)}", **attributes)
      @side = side
      @aria_id = aria_id
      super(**attributes)
    end

    def content(**attributes, &)
      PopoverContent(side: @side, aria_id: @aria_id, **attributes, &)
    end

    def trigger(**attributes, &)
      PopoverTrigger(aria_id: @aria_id, **attributes, &)
    end

    def default_attributes
      {
        data: {
          controller: "popover",
          side: @side,
        },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
