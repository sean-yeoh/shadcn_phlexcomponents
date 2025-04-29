# frozen_string_literal: true

module ShadcnPhlexcomponents
  class DateRangePicker < Base
    STYLES = <<~HEREDOC
      flex w-full rounded-md border border-input bg-transparent px-3 pr-10 h-9
      text-base shadow-sm transition-colors placeholder:text-muted-foreground
      outline-none data-[focus=true]:ring-1 data-[focus=true]:ring-ring
      data-disabled:cursor-not-allowed data-disabled:opacity-50 md:text-sm relative
      items-center
    HEREDOC

    INPUT_STYLES = <<~HEREDOC
      h-9 py-1
      text-base md:text-sm outline-none w-[45%]
    HEREDOC

    CLEAR_BUTTON_STYLES = TAILWIND_MERGER.merge("#{Button.default_styles(
      variant: :ghost,
      size: :icon,
    )} text-muted-foreground h-6 w-6")

    def initialize(start_date: nil, end_date: nil, start_date_name: nil, end_date_name: nil, format: "DD/MM/YYYY",
      disabled: false, settings: {}, **attributes)
      @start_date = start_date&.utc&.iso8601
      @end_date = end_date&.utc&.iso8601
      @start_date_name = start_date_name
      @end_date_name = end_date_name
      @settings = settings
      @format = format
      @disabled = disabled
      super(**attributes)
    end

    def default_attributes
      {
        data: {
          start_date: @start_date,
          end_date: @end_date,
          format: @format,
          controller: "shadcn-phlexcomponents--date-range-picker",
          settings: @settings.to_json,
          has_value: (@start_date.present? && @end_date.present?).to_s,
          disabled: @disabled,
          action: <<~HEREDOC,
            mouseover->shadcn-phlexcomponents--date-range-picker#showClearButton
            mouseout->shadcn-phlexcomponents--date-range-picker#hideClearButton
          HEREDOC
        },
      }
    end

    def view_template
      div(**@attributes) do
        input(type: :text, class: INPUT_STYLES, data: {
          "shadcn-phlexcomponents--date-range-picker-target": "startDateInput",
          action: <<~HEREDOC,
            focus->shadcn-phlexcomponents--date-range-picker#openCalendar
            input->shadcn-phlexcomponents--date-range-picker#changeDate
            keydown->shadcn-phlexcomponents--date-range-picker#closeCalendar
          HEREDOC
        })
        input(
          type: :hidden,
          name: @start_date_name,
          value: @start_date,
          data: { "shadcn-phlexcomponents--date-range-picker-target": "startDateHiddenInput" },
        )

        icon("minus", class: "size-4 text-muted-foreground px-3 w-[10%]")

        input(type: :text, class: INPUT_STYLES, data: {
          "shadcn-phlexcomponents--date-range-picker-target": "endDateInput",
          action: <<~HEREDOC,
            focus->shadcn-phlexcomponents--date-range-picker#openCalendar
            input->shadcn-phlexcomponents--date-range-picker#changeDate
            keydown->shadcn-phlexcomponents--date-range-picker#closeCalendar
          HEREDOC
        })
        input(
          type: :hidden,
          name: @end_date_name,
          value: @end_date,
          data: { "shadcn-phlexcomponents--date-range-picker-target": "endDateHiddenInput" },
        )

        div(class: "absolute right-3 inset-y-0 flex items-center -z-1") do
          span(class: "pointer-events-none size-6 inline-flex items-center justify-center") do
            icon(
              "calendar",
              class: "size-4 text-muted-foreground",
              data: { "shadcn-phlexcomponents--date-range-picker-target": "calendarIcon" },
            )
          end
        end

        div(class: "absolute right-3 inset-y-0 flex items-center") do
          button(
            type: :button,
            class: "#{CLEAR_BUTTON_STYLES} !hidden",
            tabindex: -1,
            data: {
              action: "shadcn-phlexcomponents--date-range-picker#clear:stop",
              "shadcn-phlexcomponents--date-range-picker-target": "clearButton",
            },
          ) do
            icon("x")
          end
        end
      end
    end
  end
end
