# frozen_string_literal: true

module ShadcnPhlexcomponents
  class TooltipContent < Base
    STYLES = <<~HEREDOC
      overflow-hidden rounded-md bg-primary px-3 py-1.5 text-xs text-primary-foreground
      animate-in fade-in-0 zoom-in-95
      data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2
      data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2
    HEREDOC

    def initialize(side: :top, aria_id: nil, **attributes)
      @side = side
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      div(class: "hidden", data: { "shadcn-phlexcomponents--tooltip-target": "content" }) do
        div(**@attributes, &)

        span(
          id: "#{@aria_id}-content",
          role: "tooltip",
          class: "sr-only",
          &
        )
      end
    end

    def default_attributes
      {
        data: {
          side: @side,
        },
      }
    end
  end
end
