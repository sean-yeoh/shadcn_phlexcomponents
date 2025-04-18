# frozen_string_literal: true

module ShadcnPhlexcomponents
  class DialogHeader < Base
    STYLES = "flex flex-col space-y-1.5 text-center sm:text-left"

    def view_template(&)
      div(**@attributes, &)
    end
  end
end