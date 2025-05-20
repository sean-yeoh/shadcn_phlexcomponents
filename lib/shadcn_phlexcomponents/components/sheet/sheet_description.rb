# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SheetDescription < Base
    STYLES = "text-sm text-muted-foreground"

    def initialize(aria_id: nil, **attributes)
      @aria_id = aria_id
      super(**attributes)
    end

    def default_attributes
      {
        id: "#{@aria_id}-description",
      }
    end

    def view_template(&)
      p(**@attributes, &)
    end
  end
end
