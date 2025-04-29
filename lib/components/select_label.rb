# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SelectLabel < Base
    STYLES = "px-2 py-1.5 text-sm font-semibold"

    def initialize(aria_id: nil, **attributes)
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      div(**@attributes, &)
    end

    def default_attributes
      {
        data: {
          "shadcn-phlexcomponents--select-target": "label",
        },
      }
    end
  end
end
