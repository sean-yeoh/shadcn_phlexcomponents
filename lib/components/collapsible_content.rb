# frozen_string_literal: true

module ShadcnPhlexcomponents
  class CollapsibleContent < Base

    def initialize(aria_id: :nil, **attributes)
      @aria_id = aria_id
      super(**attributes)
    end

    def default_attributes
      {
        id: "#{@aria_id}-content",
        data: {
          "shadcn-phlexcomponents--collapsible-target": "content"
        }
      }
    end

    def view_template(&)
      @class = @attributes.delete(:class)
      div(class: "#{@class} hidden", **@attributes, &)
    end
  end
end
