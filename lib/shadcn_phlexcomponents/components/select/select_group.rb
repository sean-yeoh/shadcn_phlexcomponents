# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SelectGroup < Base
    def initialize(aria_id:, **attributes)
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      div(**@attributes, &)
    end

    def default_attributes
      {
        role: "group",
        data: {
          "select-target": "group",
        },
      }
    end
  end
end
