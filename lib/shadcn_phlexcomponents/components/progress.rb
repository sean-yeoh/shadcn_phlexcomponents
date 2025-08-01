# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Progress < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.progress&.dig(:root) ||
        {
          base: "bg-primary/20 relative h-2 w-full overflow-hidden rounded-full",
        }
      ),
    )

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
        ProgressIndicator(value: @value)
      end
    end
  end

  class ProgressIndicator < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.progress&.dig(:indicator) ||
        {
          base: "bg-primary h-full w-full flex-1 transition-all",
        }
      ),
    )

    def initialize(value: nil, **attributes)
      @value = value
      super(**attributes)
    end

    def default_attributes
      value = @value || 0
      {
        style: "transform: translateX(-#{100 - value}%)",
        data: { progress_target: "indicator" },
      }
    end

    def view_template
      div(**@attributes)
    end
  end
end
