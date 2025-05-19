# frozen_string_literal: true

module ShadcnPhlexcomponents
  class DropdownMenuContent < Base
    STYLES = <<~HEREDOC
      z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1
      text-popover-foreground shadow-md outline-none
      data-[state=open]:animate-in pointer-events-auto
      data-[state=closed]:animate-out data-[state=closed]:fade-out-0
      data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95
      data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2
      data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2
      data-[side=top]:slide-in-from-bottom-2
    HEREDOC

    def initialize(side: :bottom, aria_id: nil, **attributes)
      @side = side
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      div(
        class: "hidden fixed top-0 left-0 w-max z-50",
        data: { "dropdown-menu-target": "contentWrapper" },
      ) do
        div(**@attributes, &)
      end
    end

    def default_attributes
      {
        id: "#{@aria_id}-content",
        tabindex: -1,
        role: "menu",
        aria: {
          labelledby: "#{@aria_id}-trigger",
          orientation: "vertical",
        },
        data: {
          state: "closed",
          side: @side,
          "dropdown-menu-target": "content",
          action: <<~HEREDOC,
            keydown.up->dropdown-menu#focusLastItem:prevent
            keydown.down->dropdown-menu#focusFirstItem:prevent
          HEREDOC
        },
      }
    end
  end
end
