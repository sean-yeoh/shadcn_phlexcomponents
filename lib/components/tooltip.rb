# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Tooltip < Base
    STYLES = "inline-block".freeze

    def initialize(side: :top, aria_id: "tooltip-#{SecureRandom.hex(5)}", **attributes)
      @side = side
      @aria_id = aria_id
      super(**attributes)
    end

    def trigger(**attributes, &)
      render TooltipTrigger.new(aria_id: @aria_id, **attributes, &)
    end

    def content(**attributes, &)
      render TooltipContent.new(side: @side, aria_id: @aria_id, **attributes, &)
    end 

    def default_attributes
      {
        data: {
          controller: "shadcn-phlexcomponents--tooltip",
          side: @side
        }
      }  
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end
end