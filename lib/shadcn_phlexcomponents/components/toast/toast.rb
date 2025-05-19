# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Toast < Base
    STYLES = <<~HEREDOC
      group pointer-events-auto relative flex w-full items-center justify-between
      space-x-2 overflow-hidden rounded-md border p-4 pr-6 shadow-lg transition-all
      data-[state=open]:animate-in data-[state=closed]:animate-out#{" "}
      data-[state=closed]:fade-out-80 data-[state=closed]:slide-out-to-right-full
      data-[state=open]:slide-in-from-top-full data-[state=open]:sm:slide-in-from-bottom-full
    HEREDOC

    CLOSE_BUTTON_STYLES = <<~HEREDOC
      absolute right-1 top-1 rounded-md p-1 text-foreground/50 opacity-0 transition-opacity
      hover:text-foreground focus:opacity-100 focus:outline-none focus:ring-1 group-hover:opacity-100
      group-[.destructive]:text-red-300 group-[.destructive]:hover:text-red-50 group-[.destructive]:focus:ring-red-400
      group-[.destructive]:focus:ring-offset-red-600 cursor-pointer
    HEREDOC

    VARIANTS = {
      default: "border bg-background text-foreground",
      destructive: "destructive group border-destructive bg-destructive text-destructive-foreground",
    }.freeze

    def initialize(variant: :default, duration: 5000, **attributes)
      @variant = variant
      @duration = duration
      super(**attributes)
    end

    def title(**attributes, &)
      ToastTitle(data: { title: "" }, **attributes, &)
    end

    def description(**attributes, &)
      ToastDescription(data: { description: "" }, **attributes, &)
    end

    def content(**attributes, &)
      ToastContent(**attributes, &)
    end

    def action(**attributes, &)
      ToastAction(variant: @variant, **attributes, &)
    end

    def action_to(name = nil, options = nil, html_options = nil, &block)
      if block_given?
        options ||= {}
        options[:variant] = @variant
      else
        html_options ||= {}
        html_options[:variant] = @variant
      end

      ToastActionTo(name, options, html_options, &block)
    end

    def default_styles
      "#{STYLES} #{VARIANTS[@variant]}"
    end

    def default_attributes
      {
        role: "status",
        tabindex: 0,
        aria: {
          live: "off",
          atomic: "true",
        },
        data: {
          duration: @duration,
          state: "open",
          controller: "toast",
          action: <<~HEREDOC,
            focus->toast#cancelDismiss
            blur->toast#dismiss
            mouseover->toast#cancelDismiss
            mouseout->toast#dismiss
            keydown.esc->toast#close
          HEREDOC
        },
      }
    end

    def view_template(&)
      li(**@attributes) do
        yield
        button(
          type: "button",
          class: CLOSE_BUTTON_STYLES,
          data: {
            action: "toast#close",
          },
        ) do
          icon("x", class: "size-4")
        end
      end
    end
  end
end
