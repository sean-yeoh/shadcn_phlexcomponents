# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Toggle < Base
    class_variants(
      base: <<~HEREDOC,
        inline-flex items-center justify-center gap-2 rounded-md text-sm font-medium hover:bg-muted
        hover:text-muted-foreground disabled:pointer-events-none disabled:opacity-50 data-[state=on]:bg-accent
        data-[state=on]:text-accent-foreground [&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4
        [&_svg]:shrink-0 focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] outline-none
        transition-[color,box-shadow] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40
        aria-invalid:border-destructive whitespace-nowrap
      HEREDOC
      variants: {
        variant: {
          default: "bg-transparent",
          outline: "border border-input bg-transparent shadow-xs hover:bg-muted hover:text-muted-foreground",
        },
        size: {
          default: "h-9 px-2 min-w-9",
          sm: "h-8 px-1.5 min-w-8",
          lg: "h-10 px-2.5 min-w-10",
        },
      },
      defaults: {
        variant: :default,
        size: :default,
      },
    )

    def initialize(variant: :default, size: :default, on: false, **attributes)
      @class_variants = { variant: variant, size: size }
      @on = on
      super(**attributes)
    end

    def default_attributes
      {
        aria: {
          pressed: @on.to_s,
        },
        data: {
          controller: "toggle",
          toggle_is_on_value: @on.to_s,
          action: "click->toggle#toggle",
        },
      }
    end

    def view_template(&)
      button(**@attributes, &)
    end
  end
end
