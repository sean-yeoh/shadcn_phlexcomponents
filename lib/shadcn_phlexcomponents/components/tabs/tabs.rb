# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Tabs < Base
    def initialize(value: nil, dir: "ltr", aria_id: "tabs-#{SecureRandom.hex(5)}", **attributes)
      @dir = dir
      @value = value
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      div(**@attributes, &)
    end

    def default_attributes
      {
        dir: @dir,
        data: {
          controller: "tabs",
          "tabs-selected-value": @value,
        },
      }
    end

    def list(**attributes, &)
      TabsList(**attributes, &)
    end

    def trigger(**attributes, &)
      TabsTrigger(aria_id: @aria_id, **attributes, &)
    end

    def content(**attributes, &)
      TabsContent(aria_id: @aria_id, **attributes, &)
    end
  end
end
