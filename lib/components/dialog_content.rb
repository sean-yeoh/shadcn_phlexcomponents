# frozen_string_literal: true

class DialogContent < BaseComponent
  STYLES = <<~HEREDOC
    fixed left-[50%] top-[50%] z-51 grid w-full max-w-lg translate-x-[-50%]
    translate-y-[-50%] gap-4 border bg-background p-6 shadow-lg duration-200
    data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0
    data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95
    data-[state=closed]:slide-out-to-left-1/2 data-[state=closed]:slide-out-to-top-[48%]
    data-[state=open]:slide-in-from-left-1/2 data-[state=open]:slide-in-from-top-[48%] sm:rounded-lg
  HEREDOC

  CLOSE_BUTTON_STYLES = <<~HEREDOC
    absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background
    transition-opacity hover:opacity-100 focus:outline-none focus:ring-2
    focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none
  HEREDOC

  def initialize(aria_id:, **attributes)
    @aria_id = aria_id
    super(**attributes)
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
        "shadcn-phlexcomponents--dialog-target": "content",
      },
    }
  end

  def view_template(&)
    @class = @attributes.delete(:class)
    div(class: "#{@class} hidden", **@attributes) do
      yield

      button(class: CLOSE_BUTTON_STYLES, data: { action: "click->shadcn-phlexcomponents--dialog#close" }) do
        lucide_icon("x", class: "size-4")
        span(class: "sr-only") { "close" }
      end
    end
  end
end
