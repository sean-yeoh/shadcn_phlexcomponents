# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Switch < Base
    STYLES = <<~HEREDOC.freeze
      peer inline-flex h-6 w-11 shrink-0 cursor-pointer items-center rounded-full
      border-2 border-transparent transition-colors focus-visible:outline-none 
      focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2
      focus-visible:ring-offset-background disabled:cursor-not-allowed disabled:opacity-50
      data-[checked=true]:bg-primary data-[checked=false]:bg-input group/switch
    HEREDOC

    def initialize(name: nil, value: "1", unchecked_value: "0", checked: false, id: nil, include_hidden: true, **attributes)
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
        span(class: "pointer-events-none block h-5 w-5 rounded-full bg-background shadow-lg
                    ring-0 transition-transform group-data-[checked=true]/switch:translate-x-5
                    group-data-[checked=false]/switch:translate-x-0")

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
            "shadcn-phlexcomponents--switch-target": "input"
          }
        )
      end
    end

    def default_attributes
      { 
        id: @id,
        type: "button",
        role: "switch",
        aria: {
          checked: @checked.to_s,
        },
        data: {
          checked: @checked.to_s,
          controller: "shadcn-phlexcomponents--switch",
          action: "click->shadcn-phlexcomponents--switch#toggle",
          "shadcn-phlexcomponents--switch-checked-value": @checked,
        }
      }
    end
  end
end