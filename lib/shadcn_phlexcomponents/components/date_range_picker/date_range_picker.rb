# frozen_string_literal: true

module ShadcnPhlexcomponents
  class DateRangePicker < Base
    def initialize(
      start_date_name: nil,
      end_date_name: nil,
      id: nil,
      start_date: nil,
      end_date: nil,
      format: "DD/MM/YYYY",
      select_only: false,
      placeholder: nil,
      disabled: false,
      settings: {},
      aria_id: "date-range-picker-#{SecureRandom.hex(5)}",
      **attributes
    )
      @start_date_name = start_date_name
      @end_date_name = end_date_name
      @id = id || start_date_name
      @start_date = start_date&.utc&.iso8601
      @end_date = end_date&.utc&.iso8601
      @format = format
      @select_only = select_only
      @placeholder = placeholder
      @disabled = disabled
      @settings = settings
      @aria_id = aria_id
      super(**attributes)
    end

    def default_styles
      DatePicker::STYLES
    end

    def default_attributes
      {
        data: {
          controller: "date-range-picker",
          start_date: @start_date,
          end_date: @end_date,
          format: @format,
          settings: @settings.to_json,
        },
      }
    end

    def view_template(&)
      div(**@attributes) do
        input(
          type: :hidden,
          name: @start_date_name,
          value: @start_date,
          data: { "date-range-picker-target": "startDateHiddenInput" },
        )

        input(
          type: :hidden,
          name: @end_date_name,
          value: @end_date,
          data: { "date-range-picker-target": "endDateHiddenInput" },
        )

        if @select_only
          DateRangePickerTrigger(
            disabled: @disabled,
            aria_id: @aria_id,
            select_only: @select_only,
            select_only_id: @id,
            placeholder: @placeholder,
          )
        else
          div(
            class: DatePicker::CONTAINER_STYLES,
            data: { "date-range-picker-target": "inputContainer", disabled: @disabled },
          ) do
            input(
              id: @id,
              placeholder: @placeholder || "#{@format} - #{@format}",
              type: :text,
              class: DatePicker::INPUT_STYLES,
              disabled: @disabled,
              data: {
                "date-range-picker-target": "input",
                action: "input->date-range-picker#changeDate
                          blur->date-range-picker#resetChanges
                          focus->date-range-picker#setContainerFocus",
              },
            )

            DateRangePickerTrigger(
              disabled: @disabled,
              aria_id: @aria_id,
              select_only: @select_only,
              placeholder: @placeholder,
            )
          end
        end

        DateRangePickerContent(aria_id: @aria_id)
      end
    end
  end
end
