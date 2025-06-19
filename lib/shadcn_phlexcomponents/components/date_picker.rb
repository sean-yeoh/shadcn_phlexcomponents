# frozen_string_literal: true

module ShadcnPhlexcomponents
  class DatePicker < Base
    class_variants(base: "w-full")

    class << self
      button = Button.new

      {
        input_container: <<~HEREDOC,
          focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]
          data-[focus=true]:border-ring data-[focus=true]:ring-ring/50 data-[focus=true]:ring-[3px]
          data-[disabled]:cursor-not-allowed data-[disabled]:opacity-50 flex shadow-xs transition-[color,box-shadow]
          rounded-md border bg-transparent dark:bg-input/30 border-input outline-none h-9 flex items-center
          aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive
        HEREDOC
        input: <<~HEREDOC,
          md:text-sm placeholder:text-muted-foreground selection:bg-primary selection:text-primary-foreground
          flex h-9 w-full min-w-0 text-base outline-none px-3 py-1#{" "}
        HEREDOC
        calendar: {
          calendar: "relative flex flex-col outline-none",
          controls: "absolute z-20 -left-1 -right-1 -top-1.5 flex justify-between items-center pt-1.5 px-1 pointer-events-none box-content",
          grid: "grid gap-4 grid-cols-1 md:grid-cols-2",
          column: "flex flex-col",
          header: "relative flex items-center mb-4",
          headerContent: "grid grid-flow-col gap-x-1 auto-cols-max items-center justify-center px-4 whitespace-pre-wrap grow",
          month: button.class_variants(variant: :outline, size: :sm, class: "text-xs h-7 bg-transparent"),
          year: button.class_variants(variant: :outline, size: :sm, class: "text-xs h-7 bg-transparent"),
          arrowPrev: button.class_variants(variant: :outline, size: :icon, class: "pointer-events-auto size-7 bg-transparent p-0 opacity-50 hover:opacity-100"),
          arrowNext: button.class_variants(variant: :outline, size: :icon, class: "pointer-events-auto size-7 bg-transparent p-0 opacity-50 hover:opacity-100"),
          wrapper: "flex items-center content-center h-full",
          content: "flex flex-col grow h-full",
          months: "grid gap-2 grid-cols-4 items-center grow",
          monthsMonth: button.class_variants(variant: :ghost, class: "aria-[selected=true]:text-primary-foreground aria-[selected=true]:bg-primary aria-[selected=true]:hover:text-primary-foreground aria-[selected=true]:hover:bg-primary"),
          years: "grid gap-2 grid-cols-5 items-center grow",
          yearsYear: button.class_variants(variant: :ghost, class: "aria-[selected=true]:text-primary-foreground aria-[selected=true]:bg-primary aria-[selected=true]:hover:text-primary-foreground aria-[selected=true]:hover:bg-primary"),
          week: "grid mb-2 grid-cols-[repeat(7,_1fr)] justify-items-center items-center text-center",
          weekDay: "text-muted-foreground rounded-md w-8 font-normal text-[0.8rem]",
          weekNumbers: "vc-week-numbers",
          weekNumbersTitle: "vc-week-numbers__title",
          weekNumbersContent: "vc-week-numbers__content",
          weekNumber: "vc-week-number",
          dates: "grid gap-y-2 grid-cols-[repeat(7,_1fr)] justify-items-center items-center",
          date: <<~HEREDOC,
            vc-date data-[vc-date-selected]:[&_button]:bg-primary#{" "}
            data-[vc-date-selected]:[&_button]:text-primary-foreground#{" "}
            data-[vc-date-selected]:[&_button]:hover:bg-primary#{" "}
            data-[vc-date-selected]:[&_button]:hover:text-primary-foreground#{" "}
            data-[vc-date-selected]:[&_button]:focus:bg-primary#{" "}
            data-[vc-date-selected]:[&_button]:focus:text-primary-foreground
            data-[vc-date-today]:[&_button]:bg-accent
            data-[vc-date-today]:[&_button]:text-accent-foreground
            data-[vc-date-month=prev]:[&_button]:text-muted-foreground
            data-[vc-date-month=next]:[&_button]:text-muted-foreground
            data-[vc-date-selected='middle']:data-[vc-date-selected]:[&_button]:bg-accent
            data-[vc-date-selected='middle']:data-[vc-date-selected]:[&_button]:text-accent-foreground
            data-[vc-date-hover]:[&_button]:bg-accent data-[vc-date-hover]:[&_button]:text-accent-foreground
          HEREDOC
          dateBtn: button.class_variants(variant: :ghost, class: "size-8 p-0 font-normal aria-[disabled]:text-muted-foreground aria-[disabled]:opacity-50 aria-[disabled]:pointer-events-none"),
          datePopup: "vc-date__popup",
          dateRangeTooltip: "vc-date-range-tooltip",
          time: "vc-time",
          timeContent: "vc-time__content",
          timeHour: "vc-time__hour",
          timeMinute: "vc-time__minute",
          timeKeeping: "vc-time__keeping",
          timeRanges: "vc-time__ranges",
          timeRange: "vc-time__range",
        },
      }
    end

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
      @value = value&.utc&.iso8601
      @format = format
      @select_only = select_only
      @placeholder = placeholder
      @disabled = disabled
      @mask = mask
      @aria_id = "date-picker-#{SecureRandom.hex(5)}"
      @date_picker_styles = self.class.date_picker_styles
      @options = options.merge(styles: @date_picker_styles[:calendar])
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
            aria_id: @aria_id,
            select_only: @select_only,
            id: @id,
            placeholder: @placeholder,
          )
        else
          div(class: @date_picker_styles[:input_container], data: { date_picker_target: "inputContainer", disabled: @disabled }) do
            input(
              id: @id,
              placeholder: @placeholder || @format,
              type: :text,
              class: @date_picker_styles[:input],
              disabled: @disabled,
              data: {
                date_picker_target: "input",
                action: "input->date-picker#inputDate
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

  class DatePickerTrigger < Base
    def initialize(
      select_only: true,
      placeholder: nil,
      aria_id: nil,
      **attributes
    )
      @select_only = select_only
      @placeholder = placeholder
      @aria_id = aria_id
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
          span(class: "pointer-events-none", data: { "#{stimulus_controller_name}-target" => "triggerText" })

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
          action: "click->#{stimulus_controller_name}#toggle",
          "#{stimulus_controller_name}-target" => "trigger",
        },
      }
    end

    def stimulus_controller_name
      "date-picker"
    end
  end

  class DatePickerContent < Base
    def initialize(side: :bottom, align: :start, aria_id: nil, **attributes)
      @side = side
      @align = align
      @aria_id = aria_id
      super(**attributes)
    end

    def class_variants(**args)
      PopoverContent.new.class_variants(
        class: <<~HEREDOC,
          fixed left-1/2 top-1/2 shadow-lg -translate-x-1/2 -translate-y-1/2 pointer-events-auto w-max
          md:relative md:left-[unset] md:top-[unset] md:shadow-md md:translate-x-[unset] md:translate-y-[unset] md:pointer-events-[unset]
          #{args[:class]}
        HEREDOC
      )
    end

    def default_attributes
      {
        id: "#{@aria_id}-content",
        tabindex: -1,
        role: "dialog",
        data: {
          side: @side,
          align: @align,
          "#{stimulus_controller_name}-target" => "content",
          action: "#{stimulus_controller_name}:click:outside->#{stimulus_controller_name}#clickOutside",
        },
      }
    end

    def stimulus_controller_name
      "date-picker"
    end

    def view_template(&)
      div(
        class: "hidden fixed top-0 left-0 w-max z-50",
        data: { "#{stimulus_controller_name}-target" => "contentContainer" },
      ) do
        div(**@attributes) do
          div(data: { "#{stimulus_controller_name}-target" => "calendar" })
        end
      end
    end
  end
end
