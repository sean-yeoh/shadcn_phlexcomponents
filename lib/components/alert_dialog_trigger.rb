# frozen_string_literal: true

module ShadcnPhlexcomponents
  class AlertDialogTrigger < Base
    def initialize(as_child: false, aria_id: nil, **attributes)
      @as_child = as_child
      @aria_id = aria_id
      super(**attributes)
    end

    def default_attributes
      {
        role: "button",
        aria: {
          haspopup: "dialog",
          expanded: "false",
          controls: "#{@aria_id}-content",
        },
        data: {
          action: "click->shadcn-phlexcomponents--alert-dialog#open",
          "shadcn-phlexcomponents--alert-dialog-target": "trigger",
          as_child: @as_child.to_s,
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
