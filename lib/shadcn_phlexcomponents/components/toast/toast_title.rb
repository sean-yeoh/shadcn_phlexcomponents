# frozen_string_literal: true

module ShadcnPhlexcomponents
  class ToastTitle < Base
    STYLES = "text-sm font-semibold [&+div]:text-xs"

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
