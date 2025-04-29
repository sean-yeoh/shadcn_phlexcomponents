# frozen_string_literal: true

module ShadcnPhlexcomponents
  class ComboboxItem < Base
    def view_template(&)
      option(**@attributes, &)
    end
  end
end
