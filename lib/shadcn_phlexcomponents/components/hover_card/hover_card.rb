# frozen_string_literal: true

module ShadcnPhlexcomponents
  class HoverCard < Base
    STYLES = "inline-block max-w-fit"

    def initialize(side: :bottom, **attributes)
      @side = side
      super(**attributes)
    end

    def content(**attributes, &)
      HoverCardContent(**attributes, &)
    end

    def trigger(**attributes, &)
      HoverCardTrigger(side: @side, **attributes, &)
    end

    def default_attributes
      {
        data: {
          controller: "hover-card",
          side: @side,
        },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
