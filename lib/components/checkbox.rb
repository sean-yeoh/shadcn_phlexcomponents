# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Checkbox < Base
    STYLES = <<~HEREDOC
      peer size-4 shrink-0 rounded-sm border border-primary shadow focus-visible:outline-none
      focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50
      data-[checked=true]:bg-primary data-[checked=true]:text-primary-foreground relative
      cursor-pointer group/checkbox
    HEREDOC

    def initialize(name: nil, value: "1", unchecked_value: "0", checked: false, id: nil, include_hidden: true,
      **attributes)
      @name = name
      @value = value
      @unchecked_value = unchecked_value
      @checked = checked
      @id = id || name
      @include_hidden = include_hidden
      super(**attributes)
    end

    def view_template(&)
      button(**@attributes) do
        span(class: "absolute inset-0 items-center justify-center text-current
                    pointer-events-none hidden group-data-[checked=true]/checkbox:flex") do
          icon("check", class: "size-4")
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
            "shadcn-phlexcomponents--checkbox-target": "input",
          },
        )
      end
    end

    def default_attributes
      {
        id: @id,
        type: "button",
        role: "checkbox",
        aria: {
          checked: @checked.to_s,
        },
        data: {
          checked: @checked.to_s,
          controller: "shadcn-phlexcomponents--checkbox",
          action: <<~HEREDOC,
            click->shadcn-phlexcomponents--checkbox#toggle
            keydown.enter->shadcn-phlexcomponents--checkbox#preventDefault
          HEREDOC
          "shadcn-phlexcomponents--checkbox-checked-value": @checked,
        },
      }
    end
  end
end
