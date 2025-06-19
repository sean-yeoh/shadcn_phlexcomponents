# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Progress < Base
    class_variants(base: "bg-primary/20 relative h-2 w-full overflow-hidden rounded-full")

    def initialize(value: 0, **attributes)
      @value = value
      super(**attributes)
    end

    def default_attributes
      {
        role: "progressbar",
        aria: {
          valuemax: 100,
          valuemin: 0,
          valuenow: @value,
        },
        data: {
          controller: "progress",
          progress_percent_value: @value,
        },
      }
    end

    def view_template
      div(**@attributes) do
        div(
          class: "bg-primary h-full w-full flex-1 transition-all",
          style: "transform: translateX(-#{100 - @value}%)",
          data: { progress_target: "indicator" },
        )
      end
    end
  end
end
