# frozen_string_literal: true

module ShadcnPhlexcomponents
  class TabsContent < Base
    STYLES = <<~HEREDOC
      mt-2 ring-offset-background focus-visible:outline-none focus-visible:ring-2
      focus-visible:ring-ring focus-visible:ring-offset-2 hidden
    HEREDOC

    def initialize(value: nil, aria_id: nil, **attributes)
      @value = value
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      div(**@attributes, &)
    end

    def default_attributes
      {
        id: "#{@aria_id}-content-#{@value}",
        role: "tabpanel",
        tabindex: "0",
        aria: {
          labelledby: "#{@aria_id}-trigger-#{@value}",
        },
        data: {
          value: @value,
          "shadcn-phlexcomponents--tabs-target": "content",
        },
      }
    end
  end
end
