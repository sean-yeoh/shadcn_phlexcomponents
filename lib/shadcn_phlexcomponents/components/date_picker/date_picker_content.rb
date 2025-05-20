# frozen_string_literal: true

module ShadcnPhlexcomponents
  class DatePickerContent < Base
    STYLES = <<~HEREDOC
      z-51 bg-popover text-popover-foreground outline-none rounded-md min-w-[300px]
      fixed left-[50%] top-[50%] shadow-lg grid translate-x-[-50%] translate-y-[-50%]#{" "}
      md:relative md:left-[unset] md:top-[unset] md:shadow-md md:block md:translate-x-[unset] md:translate-y-[unset] md:min-w-auto
      data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0
      data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95
      slide-in-from-top-2
    HEREDOC

    def initialize(aria_id: nil, **attributes)
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      div(
        class: "hidden fixed top-0 left-0 w-max z-51",
        data: { "#{stimulus_controller_name}-target" => "contentWrapper" },
      ) do
        div(**@attributes) do
          div(data: { "#{stimulus_controller_name}-target" => "calendar" })
        end
      end
    end

    def default_attributes
      {
        id: "#{@aria_id}-content",
        tabindex: -1,
        role: "dialog",
        data: {
          "#{stimulus_controller_name}-target" => "content",
        },
      }
    end

    def stimulus_controller_name
      "date-picker"
    end
  end
end
