# frozen_string_literal: true

module ShadcnPhlexcomponents
  class HoverCardContent < Base
    STYLES = <<~HEREDOC
      rounded-md border w-64 bg-popover p-4 text-popover-foreground shadow-md outline-none#{" "}
      animate-in fade-in-0 zoom-in-95
      data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2
      data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2#{" "}
    HEREDOC

    def initialize(side: :bottom, **attributes)
      @side = side
      super(**attributes)
    end

    def view_template(&)
      div(class: "hidden", data: { "hover-card-target": "content" }) do
        div(**@attributes, &)
      end
    end

    def default_attributes
      {
        tabindex: -1,
        data: {
          side: @side,
        },
      }
    end
  end
end
