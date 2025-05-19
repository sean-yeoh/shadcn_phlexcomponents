# frozen_string_literal: true

module ShadcnPhlexcomponents
  class AlertTitle < Base
    STYLES = "mb-1 font-medium leading-none tracking-tight"

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
