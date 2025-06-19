# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Checkbox < Base
    class_variants(
      base: <<~HEREDOC,
        peer border-input dark:bg-input/30 data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground
        dark:data-[state=checked]:bg-primary data-[state=checked]:border-primary focus-visible:border-ring
        focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40
        aria-invalid:border-destructive size-4 shrink-0 rounded-[4px] border shadow-xs transition-shadow
        outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50
        relative
      HEREDOC
    )

    def initialize(name: nil, value: "1", unchecked_value: "0", checked: false, include_hidden: true,
      **attributes)
      @name = name
      @value = value
      @unchecked_value = unchecked_value
      @checked = checked
      @include_hidden = include_hidden
      super(**attributes)
    end

    def view_template(&)
      button(**@attributes) do
        span(
          class: "flex items-center justify-center text-current transition-none",
          data: { checkbox_target: "indicator" },
        ) do
          icon("check", class: "size-3.5")
        end

        if @include_hidden
          input(name: @name, type: "hidden", value: @unchecked_value, autocomplete: "off")
        end

        input(
          type: "checkbox",
          value: @value,
          class: "-translate-x-full pointer-events-none absolute top-0 left-0 size-4 opacity-0",
          name: @name,
          tabindex: -1,
          checked: @checked,
          aria: { hidden: true },
          data: {
            checkbox_target: "input",
          },
        )
      end
    end

    def default_attributes
      {
        type: "button",
        role: "checkbox",
        aria: {
          checked: @checked.to_s,
        },
        data: {
          checked: @checked.to_s,
          controller: "checkbox",
          action: <<~HEREDOC,
            click->checkbox#toggle
            keydown.enter->checkbox#preventDefault
          HEREDOC
          checkbox_is_checked_value: @checked,
        },
      }
    end
  end
end
