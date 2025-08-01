# frozen_string_literal: true

module ShadcnPhlexcomponents
  class DateRangePicker < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.date_picker&.dig(:root) ||
        {
          base: "w-full",
        }
      ),
    )

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
            begin
              # Use Time.zone.parse to ensure consistent timezone handling
              Time.zone ? Time.zone.parse(v) : Time.parse(v)
            rescue
              nil
            end
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
        overlay("date-range-picker")

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
          DatePickerTrigger(
            disabled: @disabled,
            select_only: @select_only,
            id: @id,
            placeholder: @placeholder,
            stimulus_controller_name: "date-range-picker",
            aria_id: @aria_id,
          )
        else

          DatePickerInputContainer(disabled: @disabled, stimulus_controller_name: "date-range-picker") do
            DatePickerInput(id: @id, placeholder: @placeholder, format: "#{@format} - #{@format}", disabled: @disabled, stimulus_controller_name: "date-range-picker", aria_id: @aria_id)

            DatePickerTrigger(
              disabled: @disabled,
              select_only: @select_only,
              placeholder: @placeholder,
              stimulus_controller_name: "date-range-picker",
              aria_id: @aria_id,
            )
          end
        end

        DatePickerContent(stimulus_controller_name: "date-range-picker", aria_id: @aria_id)
      end
    end
  end
end
