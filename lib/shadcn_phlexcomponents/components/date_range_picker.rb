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

      if value
        value = value.map do |v|
          if v.is_a?(String)
            DateTime.parse(v) rescue nil
          else
            v
          end
        end 
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
      @options = options
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
        overlay('date-range-picker')

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
            class: <<~HEREDOC,
              focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]
              data-[focus=true]:border-ring data-[focus=true]:ring-ring/50 data-[focus=true]:ring-[3px]
              data-[disabled]:cursor-not-allowed data-[disabled]:opacity-50 flex shadow-xs transition-[color,box-shadow]
              rounded-md border bg-transparent dark:bg-input/30 border-input outline-none h-9 flex items-center
              aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive
            HEREDOC
            data: { date_range_picker_target: "inputContainer", disabled: @disabled },
          ) do
            input(
              id: @id,
              placeholder: @placeholder || "#{@format} - #{@format}",
              type: :text,
              class: "md:text-sm placeholder:text-muted-foreground selection:bg-primary selection:text-primary-foreground flex h-9 w-full min-w-0 text-base outline-none px-3 py-1",
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
