# frozen_string_literal: true

module ShadcnPhlexcomponents
  class DatePicker < Base
    STYLES = "w-full"
    CONTAINER_STYLES = <<~HEREDOC
      flex rounded-md border border-input items-center shadow-sm outline-none
      data-[focus=true]:ring-1 data-[focus=true]:ring-ring focus:ring-1 focus:ring-ring
      data-[disabled]:cursor-not-allowed data-[disabled]:opacity-50
    HEREDOC
    INPUT_STYLES = <<~HEREDOC
      flex h-9 w-full bg-transparent px-3 py-1 text-base transition-colors placeholder:text-muted-foreground
      focus-visible:outline-none grow md:text-sm
    HEREDOC

    def initialize(name: nil, id: nil, value: nil, format: "DD/MM/YYYY", select_only: false, placeholder: nil,
      disabled: false, settings: {}, aria_id: "date-picker-#{SecureRandom.hex(5)}", **attributes)
      @name = name
      @id = id || @name
      @value = value&.utc&.iso8601
      @format = format
      @select_only = select_only
      @placeholder = placeholder
      @disabled = disabled
      @settings = settings
      @aria_id = aria_id
      super(**attributes)
    end

    def default_attributes
      {
        data: {
          controller: "date-picker",
          value: @value,
          format: @format,
          settings: @settings.to_json,
        },
      }
    end

    def view_template(&)
      div(**@attributes) do
        input(
          type: :hidden,
          name: @name,
          value: @value,
          data: { "date-picker-target": "hiddenInput" },
        )

        if @select_only
          DatePickerTrigger(
            disabled: @disabled,
            aria_id: @aria_id,
            select_only: @select_only,
            select_only_id: @id,
            placeholder: @placeholder,
          )
        else
          div(class: CONTAINER_STYLES, data: { "date-picker-target": "inputContainer", disabled: @disabled }) do
            input(
              id: @id,
              placeholder: @placeholder || @format,
              type: :text,
              class: INPUT_STYLES,
              disabled: @disabled,
              data: {
                "date-picker-target": "input",
                action: "input->date-picker#changeDate
                          blur->date-picker#inputBlur
                          focus->date-picker#setContainerFocus",
              },
            )

            DatePickerTrigger(
              disabled: @disabled,
              aria_id: @aria_id,
              select_only: @select_only,
              placeholder: @placeholder,
            )
          end
        end

        DatePickerContent(aria_id: @aria_id)
      end
    end
  end
end
