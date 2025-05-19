# frozen_string_literal: true

module ShadcnPhlexcomponents
  class CardHeader < Base
    STYLES = "flex flex-col space-y-1.5 p-6"

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
