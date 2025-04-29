# frozen_string_literal: true

module ShadcnPhlexcomponents
  class DatePicker < Base
    STYLES = "relative"

    INPUT_STYLES = <<~HEREDOC
      flex h-9 w-full rounded-md border border-input bg-transparent px-3 pr-10 py-1
      text-base shadow-sm transition-colors placeholder:text-muted-foreground
      focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring
      disabled:cursor-not-allowed disabled:opacity-50 md:text-sm
    HEREDOC

    CLEAR_BUTTON_STYLES = TAILWIND_MERGER.merge("#{Button.default_styles(
      variant: :ghost,
      size: :icon,
    )} text-muted-foreground h-6 w-6")

    def initialize(name: nil, id: nil, value: nil, format: "DD/MM/YYYY", disabled: false, settings: {}, **attributes)
      @name = name
      @id = id || @name
      @value = value&.utc&.iso8601
      @settings = settings
      @format = format
      @disabled = disabled
      super(**attributes)
    end

    def default_attributes
      {
        data: {
          value: @value,
          format: @format,
          controller: "shadcn-phlexcomponents--date-picker",
          settings: @settings.to_json,
          has_value: @value.present?.to_s,
          disabled: @disabled,
          action: <<~HEREDOC,
            mouseover->shadcn-phlexcomponents--date-picker#showClearButton
            mouseout->shadcn-phlexcomponents--date-picker#hideClearButton
          HEREDOC
        },
      }
    end

    def view_template
      div(**@attributes) do
        input(type: :text, id: @id, class: INPUT_STYLES, data: {
          "shadcn-phlexcomponents--date-picker-target": "dateInput",
          action: <<~HEREDOC,
            input->shadcn-phlexcomponents--date-picker#changeDate
            blur->shadcn-phlexcomponents--date-picker#inputBlur
            keydown->shadcn-phlexcomponents--date-picker#closeCalendar
          HEREDOC
        })
        input(
          type: :hidden,
          name: @name,
          value: @value,
          data: { "shadcn-phlexcomponents--date-picker-target": "hiddenInput" },
        )

        div(
          class: "absolute right-3 inset-y-0 flex items-center -z-1",
          data: {
            action: "",
          },
        ) do
          span(class: "pointer-events-none size-6 inline-flex items-center justify-center") do
            icon(
              "calendar",
              class: "size-4 text-muted-foreground",
              data: { "shadcn-phlexcomponents--date-picker-target": "calendarIcon" },
            )
          end
        end

        div(class: "absolute right-3 inset-y-0 flex items-center") do
          button(
            type: :button,
            class: "#{CLEAR_BUTTON_STYLES} !hidden",
            tabindex: -1,
            data: {
              action: "shadcn-phlexcomponents--date-picker#clear:stop",
              "shadcn-phlexcomponents--date-picker-target": "clearButton",
            },
          ) do
            icon("x")
          end
        end
      end
    end
  end
end
