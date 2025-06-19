# frozen_string_literal: true

module ShadcnPhlexcomponents
  class DateRangePicker < Base
    class_variants(base: "w-full")

    def initialize(
      name: nil,
      value: nil,
      id: nil,
      format: "DD/MM/YYYY",
      select_only: false,
      placeholder: nil,
      disabled: false,
      options: {},
      mask: true,
      **attributes
    )
      if name && !name.is_a?(Array)
        raise ArgumentError, "Expected an array for \"name\", got #{name.class}"
      end

      if value && !value.is_a?(Array)
        raise ArgumentError, "Expected an array for \"value\", got #{value.class}"
      end

      @name = name ? name[0] : nil
      @end_name = name ? name[1] : nil
      @value = (value ? value[0] : nil)&.utc&.iso8601
      @end_value = (value ? value[1] : nil)&.utc&.iso8601
      @id = id
      @format = format
      @select_only = select_only
      @placeholder = placeholder
      @disabled = disabled
      @mask = mask
      @aria_id = "date-range-picker-#{SecureRandom.hex(5)}"
      @date_picker_styles = DatePicker.date_picker_styles
      @options = options.merge(styles: @date_picker_styles[:calendar])
      super(**attributes)
    end

    def default_attributes
      {
        data: {
          controller: "date-range-picker",
          value: @value,
          end_value: @end_value,
          format: @format,
          options: @options.to_json,
          mask: @mask.to_s,
        },
      }
    end

    def view_template(&)
      div(**@attributes) do
        input(
          type: :hidden,
          name: @name,
          value: @value,
          data: { date_range_picker_target: "hiddenInput" },
        )

        input(
          type: :hidden,
          name: @end_name,
          value: @end_value,
          data: { date_range_picker_target: "endHiddenInput" },
        )

        if @select_only
          # For select_only date picker, id is passed to button so that clicking on its
          # label will trigger the popover to appear
          DateRangePickerTrigger(
            disabled: @disabled,
            aria_id: @aria_id,
            select_only: @select_only,
            id: @id,
            placeholder: @placeholder,
          )
        else
          div(
            class: @date_picker_styles[:input_container],
            data: { date_range_picker_target: "inputContainer", disabled: @disabled },
          ) do
            input(
              id: @id,
              placeholder: @placeholder || "#{@format} - #{@format}",
              type: :text,
              class: @date_picker_styles[:input],
              disabled: @disabled,
              data: {
                date_range_picker_target: "input",
                action: "input->date-range-picker#inputDate
                          blur->date-range-picker#inputBlur
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

  class DateRangePickerTrigger < DatePickerTrigger
    def stimulus_controller_name
      "date-range-picker"
    end
  end

  class DateRangePickerContent < DatePickerContent
    def stimulus_controller_name
      "date-range-picker"
    end
  end
end
