# frozen_string_literal: true

module ShadcnPhlexcomponents
  class HoverCardContent < Base
    STYLES = <<~HEREDOC.freeze
      z-50 rounded-md border w-64 bg-popover p-4 text-popover-foreground shadow-md outline-none 
      data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0
      data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95
      data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2
      data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 
    HEREDOC
  
    def initialize(side: :bottom, **attributes)
      @side = side
      super(**attributes)
    end


    def view_template(&)
      div(class: 'hidden fixed top-0 left-0 w-max z-50', data: { "shadcn-phlexcomponents--hover-card-target": "contentWrapper" }) do
        div(**@attributes, &)
      end
    end

    def default_attributes
      {
        tabindex: -1,
        data: {
          side: @side,
          "shadcn-phlexcomponents--hover-card-target": "content",
          action: "mouseover->shadcn-phlexcomponents--hover-card#clearCloseTimer mouseout->shadcn-phlexcomponents--hover-card#closeWithDelay"
        }
      }
    end
  end
end