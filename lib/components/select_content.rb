# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SelectContent < Base
    STYLES = <<~HEREDOC.freeze
      relative z-50 min-w-[8rem] max-h-108 overflow-y-auto overflow-x-hidden rounded-md border
      bg-popover text-popover-foreground  p-1 shadow-md outline-none
      data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0
      data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95
      data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2
      data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2
      data-[side=bottom]:translate-y-1 data-[side=left]:-translate-x-1 
      data-[side=right]:translate-x-1 data-[side=top]:-translate-y-1
    HEREDOC

    def initialize(side: :bottom, include_blank: false, native: false, dir: "ltr", aria_id: nil, **attributes)
      @side = side
      @include_blank = include_blank
      @native = native
      @dir = dir
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      div(class: "hidden fixed top-0 left-0 w-max z-50", data: { "shadcn-phlexcomponents--select-target": "contentWrapper" }) do
        div(**@attributes) do
          if @include_blank && !@native
            SelectItem(aria_id: @aria_id, value: "", class: "h-8", hide_icon: true) { @include_blank.is_a?(String) ? @include_blank : "" }
          end

          yield
        end
      end
    end

    def default_attributes
      {
        id: "#{@aria_id}-content",
        dir: @dir,
        tabindex: -1,
        role: "listbox",
        aria: {
          labelledby: "#{@aria_id}-trigger",
          orientation: "vertical"
        },
        data: {
          state: "closed",
          side: @side,
          "shadcn-phlexcomponents--select-target": "content",
          action: <<~HEREDOC,
            keydown.up->shadcn-phlexcomponents--select#focusLastItem:prevent
            keydown.down->shadcn-phlexcomponents--select#focusFirstItem:prevent
          HEREDOC
        }
      }
    end
  end
end