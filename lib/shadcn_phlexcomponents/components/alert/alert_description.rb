# frozen_string_literal: true

module ShadcnPhlexcomponents
  class AlertDescription < Base
    STYLES = "text-sm [&_p]:leading-relaxed"

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
