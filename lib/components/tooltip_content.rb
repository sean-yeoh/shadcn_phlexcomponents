# frozen_string_literal: true

module ShadcnPhlexcomponents
  class TooltipContent < Base
    STYLES = <<~HEREDOC.freeze
      z-50 overflow-hidden rounded-md bg-primary px-3 py-1.5 text-xs text-primary-foreground
      animate-in fade-in-0 zoom-in-95 data-[state=closed]:animate-out data-[state=closed]:fade-out-0
      data-[state=closed]:zoom-out-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2
      data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2
    HEREDOC

    def initialize(side: :top, aria_id: nil, **attributes)
      @side = side
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      div(class: 'hidden fixed top-0 left-0 w-max z-50', data: { "shadcn-phlexcomponents--tooltip-target": "contentWrapper" }) do
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
        tabindex: -1,
        data: {
          side: @side,
          "shadcn-phlexcomponents--tooltip-target": "content",
          action: "mouseover->shadcn-phlexcomponents--tooltip#clearCloseTimer mouseout->shadcn-phlexcomponents--tooltip#closeWithDelay"
        }
      }
    end
  end
end