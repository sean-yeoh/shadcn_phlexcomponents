# frozen_string_literal: true

module ShadcnPhlexcomponents

  class SheetContent < Base
    STYLES = <<~HEREDOC.freeze
      fixed z-50 gap-4 bg-background p-6 shadow-lg transition ease-in-out
      data-[state=closed]:duration-300 data-[state=open]:duration-500
      data-[state=open]:animate-in data-[state=closed]:animate-out
    HEREDOC

    CLOSE_BUTTON_STYLES = <<~HEREDOC.freeze
      absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background
      transition-opacity hover:opacity-100 focus:outline-none focus:ring-2
      focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none
      cursor-pointer
    HEREDOC

    SIDES = {
      left: "inset-y-0 left-0 h-full w-3/4 border-r data-[state=closed]:slide-out-to-left data-[state=open]:slide-in-from-left sm:max-w-sm",
      right: "inset-y-0 right-0 h-full w-3/4 border-l data-[state=closed]:slide-out-to-right data-[state=open]:slide-in-from-right sm:max-w-sm",
      top: "inset-x-0 top-0 border-b data-[state=closed]:slide-out-to-top data-[state=open]:slide-in-from-top",
      bottom: "inset-x-0 bottom-0 border-t data-[state=closed]:slide-out-to-bottom data-[state=open]:slide-in-from-bottom"
    }

    def self.default_styles(side)
      "#{STYLES} #{SIDES[side]}"
    end

    def initialize(side: :right, aria_id: nil, **attributes)
      @side = side
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      @class = @attributes.delete(:class)
      div(class: "#{@class} hidden", **@attributes) do
        yield

        button(class: CLOSE_BUTTON_STYLES, data: { action: "click->shadcn-phlexcomponents--sheet#close" }) do
          icon("x", class: "size-4")
          span(class: "sr-only") { "close" }
        end
      end
    end
    
    def default_attributes
      {
        id: "#{@aria_id}-content",
        tabindex: -1,
        role: "dialog",
        aria: {
          describedby: "#{@aria_id}-description",
          labelledby: "#{@aria_id}-title",
        },
        data: {
          "shadcn-phlexcomponents--sheet-target": "content"
        }
      }
    end

    def default_styles
      self.class.default_styles(@side)
    end
  end
end