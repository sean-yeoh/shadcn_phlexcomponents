# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Switch < Base
    class_variants(
      base: <<~HEREDOC,
        peer data-[state=checked]:bg-primary data-[state=unchecked]:bg-input focus-visible:border-ring
        focus-visible:ring-ring/50 dark:data-[state=unchecked]:bg-input/80 inline-flex h-[1.15rem]
        w-8 shrink-0 items-center rounded-full border border-transparent shadow-xs transition-all
        outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50 relative
      HEREDOC
    )

    def initialize(name: nil, value: "1", unchecked_value: "0", checked: false, include_hidden: true, disabled: false, **attributes)
      @name = name
      @value = value
      @unchecked_value = unchecked_value
      @checked = checked
      @include_hidden = include_hidden
      @disabled = disabled
      super(**attributes)
    end

    def view_template(&)
      button(**@attributes) do
        span(
          class: <<~HEREDOC,
            bg-background dark:data-[state=unchecked]:bg-foreground dark:data-[state=checked]:bg-primary-foreground
            pointer-events-none block size-4 rounded-full ring-0 transition-transform
            data-[state=checked]:translate-x-[calc(100%-2px)] data-[state=unchecked]:translate-x-0
          HEREDOC
          data: {
            switch_target: "thumb",
            state: @checked ? "checked" : "unchecked",
          },
        )

        if @include_hidden
          input(name: @name, type: "hidden", value: @unchecked_value, autocomplete: "off")
        end

        input(
          type: "checkbox",
          value: @value,
          class: "-translate-x-full pointer-events-none absolute m-0 top-0 left-0 size-4 opacity-0",
          name: @name,
          disabled: @disabled,
          tabindex: -1,
          checked: @checked,
          aria: { hidden: "true" },
          data: {
            switch_target: "input",
          },
        )
      end
    end

    def default_attributes
      {
        type: "button",
        role: "switch",
        disabled: @disabled,
        aria: {
          checked: @checked.to_s,
        },
        data: {
          state: @checked ? "checked" : "unchecked",
          controller: "switch",
          action: "click->switch#toggle",
          switch_is_checked_value: @checked.to_s,
        },
      }
    end
  end
end
