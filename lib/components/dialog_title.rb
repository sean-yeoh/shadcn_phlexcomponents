# frozen_string_literal: true

module ShadcnPhlexcomponents
  class DialogTitle < Base
    STYLES = "text-lg font-semibold leading-none tracking-tight"

    def initialize(aria_id: nil, **attributes)
      @aria_id = aria_id
      super(**attributes)
    end

    def default_attributes
      {
        id: "#{@aria_id}-title",
      }
    end

    def view_template(&)
      h2(**@attributes, &)
    end
  end
end