# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Separator < Base
    ORIENTATIONS = {
      horizontal: "shrink-0 bg-border h-[1px] w-full",
      vertical: "shrink-0 bg-border h-full w-[1px]",
    }.freeze

    def initialize(orientation: :horizontal, **attributes)
      @orientation = orientation
      super(**attributes)
    end

    def default_styles
      "#{ORIENTATIONS[@orientation]}"
    end

    def default_attributes
      {
        role: "none"
      }
    end

    def view_template
      div(**@attributes)
    end
  end
end