# frozen_string_literal: true

module ShadcnPhlexcomponents
  class AlertDialogTitle < Base
    STYLES = "text-lg font-semibold"

    def initialize(aria_id:, **attributes)
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
