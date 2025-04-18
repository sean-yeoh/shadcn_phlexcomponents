# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Progress < Base
    STYLES = "relative h-2 w-full overflow-hidden rounded-full bg-primary/20"

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
          controller: "shadcn-phlexcomponents--progress",
          "shadcn-phlexcomponents--progress-progress-value": @value
        }
      }
    end

    def view_template
      div(**@attributes) do
        div(
          class: "h-full w-full flex-1 bg-primary transition-all", 
          style: "transform: translateX(-#{100-@value}%)", 
          data: { "shadcn-phlexcomponents--progress-target": "bar"}
        )
      end
    end
  end
end