# frozen_string_literal: true

module ShadcnPhlexcomponents
  class CollapsibleTrigger < Base
    def initialize(open: false, as_child: false, aria_id: nil, **attributes)
      @open = open
      @as_child = as_child
      @aria_id = aria_id
      super(**attributes)
    end

    def default_attributes
      {
        role: "button",
        aria: {
          expanded: @open.to_s,
          controls: "#{@aria_id}-content",
        },
        data: {
          state: @open ? "open" : "closed",
          action: "click->collapsible#toggle",
          "collapsible-target": "trigger",
        },
      }
    end

    def view_template(&)
      if @as_child
        content = capture(&)
        element = find_as_child(content.to_s)

        vanish(&)
        element_attributes = nokogiri_attributes_to_hash(element)
        styles = TAILWIND_MERGER.merge("#{@attributes[:class]} #{element_attributes[:class]}")
        merged_attributes = mix(@attributes, element_attributes)
        merged_attributes[:class] = styles

        if element.name == "button"
          merged_attributes.delete(:role)
        end

        send(element.name, **merged_attributes) do
          sanitize_as_child(element.children.to_s)
        end
      else
        div(**@attributes, &)
      end
    end
  end
end
