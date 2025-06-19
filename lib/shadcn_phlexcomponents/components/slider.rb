# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Slider < Base
    def initialize(name: nil, value: nil, id: nil, range: false, orientation: :horizontal, step: 1, min: 0, max: 100, disabled: false, options: false, **attributes)
      if range
        if name && !name.is_a?(Array)
          raise ArgumentError, "Expected an array for \"name\", got #{name.class}"
        end

        if value && !value.is_a?(Array)
          raise ArgumentError, "Expected an array for \"value\", got #{value.class}"
        end
      end
      @range = range
      @name = range && name ? name[0] : name
      @end_name = range && name ? name[1] : nil
      @value = range && value ? value[0] : value
      @end_value = range && value ? value[1] : nil
      @id = id
      @orientation = orientation
      @step = step
      @min = min
      @max = max
      @disabled = disabled
      @options = options
      super(**attributes)
    end

    def default_attributes
      {
        data: {
          controller: "slider",
          range: @range.to_s,
          options: @options.to_json,
          value: @value,
          end_value: @end_value,
          orientation: @orientation,
          step: @step,
          min: @min,
          max: @max,
          disabled: @disabled.to_s,
          id: @id,
        },
      }
    end

    def view_template
      div(class: "py-[6px]") do
        div(**@attributes) do
          input(
            type: :hidden,
            name: @name,
            value: @value,
            data: { slider_target: "hiddenInput" },
          )

          if @range
            input(
              type: :hidden,
              name: @end_name,
              value: @end_value,
              data: { slider_target: "endHiddenInput" },
            )
          end

          div(data: { slider_target: "slider" })
        end
      end
    end
  end
end
