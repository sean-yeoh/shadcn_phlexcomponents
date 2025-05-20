# frozen_string_literal: true

module ShadcnPhlexcomponents
  class ToastDescription < Base
    STYLES = "text-sm opacity-90"

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
