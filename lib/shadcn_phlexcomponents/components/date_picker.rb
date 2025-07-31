# frozen_string_literal: true

module ShadcnPhlexcomponents
  class DatePicker < Base
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
      id: nil,
      value: nil,
      format: "DD/MM/YYYY",
      select_only: false,
      placeholder: nil,
      disabled: false,
      options: {},
      mask: true,
      **attributes
    )
      @name = name
      @id = id

      if value
        value = if value.is_a?(String)
          begin
            Time.parse(value)
          rescue
            nil
          end
        else
          value
        end
      end

      @value = value&.utc&.iso8601
      @format = format
      @select_only = select_only
      @placeholder = placeholder
      @disabled = disabled
      @mask = mask
      @aria_id = "date-picker-#{SecureRandom.hex(5)}"
      @options = options
      super(**attributes)
    end

    def default_attributes
      {
        data: {
          controller: "date-picker",
          value: @value,
          format: @format,
          options: @options.to_json,
          mask: @mask.to_s,
        },
      }
    end

    def view_template(&)
      div(**@attributes) do
        overlay("date-picker")

        input(
          type: :hidden,
          name: @name,
          value: @value,
          data: { date_picker_target: "hiddenInput" },
        )

        if @select_only
          # For select_only date picker, id is passed to button so that clicking on its
          # label will trigger the popover to appear
          DatePickerTrigger(
            disabled: @disabled,
            select_only: @select_only,
            id: @id,
            placeholder: @placeholder,
            stimulus_controller_name: "date-picker",
            aria_id: @aria_id,
          )
        else
          DatePickerInputContainer(disabled: @disabled, stimulus_controller_name: "date-picker") do
            DatePickerInput(id: @id, placeholder: @placeholder, format: @format, disabled: @disabled, stimulus_controller_name: "date-picker", aria_id: @aria_id)

            DatePickerTrigger(
              disabled: @disabled,
              select_only: @select_only,
              placeholder: @placeholder,
              stimulus_controller_name: "date-picker",
              aria_id: @aria_id,
            )
          end
        end

        DatePickerContent(stimulus_controller_name: "date-picker", aria_id: @aria_id)
      end
    end
  end

  class DatePickerTrigger < Base
    def initialize(
      select_only: true,
      placeholder: nil,
      stimulus_controller_name: nil,
      aria_id: nil,
      **attributes
    )
      @select_only = select_only
      @placeholder = placeholder
      @aria_id = aria_id
      @stimulus_controller_name = stimulus_controller_name
      super(**attributes)
    end

    def class_variants(**args)
      if @select_only
        Button.new.class_variants(variant: :outline, class: "justify-between w-full data-[placeholder]:data-[has-value=false]:text-muted-foreground #{args[:class]}")
      else
        Button.new.class_variants(variant: :ghost, size: :icon, class: "size-7 mr-1.5 disabled:!opacity-100 #{args[:class]}")
      end
    end

    def view_template
      if @select_only
        button(type: :button, disabled: @disabled, **@attributes) do
          span(class: "pointer-events-none", data: { "#{@stimulus_controller_name}-target" => "triggerText" })

          icon("calendar", class: "size-5")
        end
      else
        button(type: :button, disabled: @disabled, **@attributes) do
          icon("calendar", class: "size-5")
        end
      end
    end

    def default_attributes
      {
        aria: {
          haspopup: "dialog",
          expanded: false,
          controls: "#{@aria_id}-content",
        },
        data: {
          placeholder: @placeholder,
          action: "click->#{@stimulus_controller_name}#toggle",
          "#{@stimulus_controller_name}-target" => "trigger",
        },
      }
    end
  end

  class DatePickerContent < Base
    def initialize(side: :bottom, align: :start, stimulus_controller_name: nil, aria_id: nil, **attributes)
      @side = side
      @align = align
      @stimulus_controller_name = stimulus_controller_name
      @aria_id = aria_id
      super(**attributes)
    end

    def class_variants(**args)
      PopoverContent.new.class_variants(class: "w-fit #{args[:class]}")
    end

    def default_attributes
      {
        id: "#{@aria_id}-content",
        tabindex: -1,
        role: "dialog",
        data: {
          side: @side,
          align: @align,
          "#{@stimulus_controller_name}-target" => "content",
          action: "#{@stimulus_controller_name}:click:outside->#{@stimulus_controller_name}#clickOutside",
        },
      }
    end

    def view_template(&)
      DatePickerContentContainer(stimulus_controller_name: @stimulus_controller_name) do
        div(**@attributes) do
          div(data: { "#{@stimulus_controller_name}-target" => "calendar" })
        end
      end
    end
  end

  class DatePickerContentContainer < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.date_picker&.dig(:content_container) ||
        {
          base: "fixed top-0 left-0 w-max z-50",
        }
      ),
    )

    def initialize(stimulus_controller_name: nil, **attributes)
      @stimulus_controller_name = stimulus_controller_name
      super(**attributes)
    end

    def default_attributes
      {
        style: { display: "none" },
        data: { "#{@stimulus_controller_name}-target" => "contentContainer" },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class DatePickerInputContainer < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.date_picker&.dig(:input_container) ||
        {
          base: <<~HEREDOC,
            focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]
            data-[focus=true]:border-ring data-[focus=true]:ring-ring/50 data-[focus=true]:ring-[3px]
            data-[disabled]:cursor-not-allowed data-[disabled]:opacity-50 flex shadow-xs transition-[color,box-shadow]
            rounded-md border bg-transparent dark:bg-input/30 border-input outline-none h-9 flex items-center
            aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive
          HEREDOC
        }
      ),
    )

    def initialize(disabled: false, stimulus_controller_name: nil, **attributes)
      @disabled = disabled
      @stimulus_controller_name = stimulus_controller_name
      super(**attributes)
    end

    def default_attributes
      {
        data: {
          "#{@stimulus_controller_name}-target" => "inputContainer",
          disabled: @disabled,
        },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class DatePickerInput < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.date_picker&.dig(:input) ||
        {
          base: <<~HEREDOC,
            md:text-sm placeholder:text-muted-foreground selection:bg-primary selection:text-primary-foreground
            flex h-9 w-full min-w-0 text-base outline-none px-3 py-1
          HEREDOC
        }
      ),
    )

    def initialize(id: nil, placeholder: nil, format: nil, disabled: false, stimulus_controller_name: nil, aria_id: nil, **attributes)
      @id = id
      @placeholder = placeholder
      @format = format
      @disabled = disabled
      @stimulus_controller_name = stimulus_controller_name
      @aria_id = aria_id
      super(**attributes)
    end

    def default_attributes
      {
        id: @id || "#{@aria_id}-input",
        placeholder: @placeholder || @format,
        type: :text,
        disabled: @disabled,
        data: {
          "#{@stimulus_controller_name}-target" => "input",
          action: "input->#{@stimulus_controller_name}#inputDate
                    blur->#{@stimulus_controller_name}#inputBlur
                    focus->#{@stimulus_controller_name}#setContainerFocus",
        },
      }
    end

    def view_template
      input(**@attributes)
    end
  end
end
