# frozen_string_literal: true

module ShadcnPhlexcomponents
  class DatePickerTrigger < Base
    SELECT_ONLY_BUTTON_STYLES = <<~HEREDOC
      flex h-9 items-center justify-between whitespace-nowrap rounded-md border
      border-input bg-transparent px-3 py-2 gap-1.5 text-base md:text-sm shadow-sm ring-offset-background
      data-[placeholder]:data-[has-value=false]:text-muted-foreground focus:outline-none focus:ring-1
      focus:ring-ring disabled:cursor-not-allowed disabled:opacity-50 [&>span]:line-clamp-1
      w-full cursor-pointer hover:bg-accent hover:text-accent-foreground disabled:hover:bg-transparent
    HEREDOC

    def initialize(disabled: false, select_only: true, placeholder: nil, select_only_id: nil, aria_id: nil,
      **attributes)
      @disabled = disabled
      @select_only = select_only
      @placeholder = placeholder
      @select_only_id = select_only_id
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template
      if @select_only
        button(type: :button, disabled: @disabled, id: @select_only_id, **@attributes) do
          span(class: "pointer-events-none", data: { "#{stimulus_controller_name}-target" => "triggerText" })

          icon("calendar", class: "size-4 text-foreground")
        end
      else
        button(type: :button, disabled: @disabled, **@attributes) do
          icon("calendar")
        end
      end
    end

    def default_styles
      if @select_only
        SELECT_ONLY_BUTTON_STYLES
      else
        "#{Button.default_styles(variant: :ghost, size: :icon)} mr-1.25 h-7 w-8 disabled:!opacity-100"
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
end
