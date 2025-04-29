# frozen_string_literal: true

module ShadcnPhlexcomponents
  class ToastContent < Base
    STYLES = "grid gap-1"

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
