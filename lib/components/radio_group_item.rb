# frozen_string_literal: true

module ShadcnPhlexcomponents
  class RadioGroupItem < Base
    STYLES = <<~HEREDOC.freeze
      aspect-square h-4 w-4 rounded-full border border-primary text-primary shadow
      focus:outline-none focus-visible:ring-1 focus-visible:ring-ring
      disabled:cursor-not-allowed disabled:opacity-50 relative cursor-pointer
      group/radio
    HEREDOC

    def initialize(name: nil, value: nil, checked: false, id: nil, **attributes)
      @value = value
      @name = name
      @checked = checked
      @id = id || name
      super(**attributes)
    end

    def view_template(&)
      button(**@attributes) do
        span(
            class: "items-center justify-center hidden group-data-[checked=true]/radio:flex"
          ) do
          icon("circle", class: "size-2.5 fill-primary")
        end

        input(
          type: "radio",
          value: @value,
          class: "-translate-x-full pointer-events-none absolute top-0 left-0 size-4 opacity-0",
          name: @name,
          tabindex: -1,
          checked: @checked,
          aria: { hidden: true },
          data: { input: "" }
        )
      end
    end

    def default_attributes
      {
        id: @id,
        type: "button",
        tabindex: -1,
        role: "radio",
        aria: {
          checked: @checked.to_s,
        }, 
        data: {
          checked: @checked.to_s,
          value: @value,
          "shadcn-phlexcomponents--radio-group-target": "item",
          action: <<~HEREDOC
            click->shadcn-phlexcomponents--radio-group#setChecked
            keydown.right->shadcn-phlexcomponents--radio-group#setCheckedToNext:prevent
            keydown.down->shadcn-phlexcomponents--radio-group#setCheckedToNext:prevent
            keydown.up->shadcn-phlexcomponents--radio-group#setCheckedToPrev:prevent
            keydown.left->shadcn-phlexcomponents--radio-group#setCheckedToPrev:prevent
            keydown.enter->shadcn-phlexcomponents--radio-group#preventDefault
          HEREDOC
        }
      }
    end
  end
end