# frozen_string_literal: true

class AlertDialogTrigger < BaseComponent
  def initialize(aria_id:, as_child: false, **attributes)
    @as_child = as_child
    @aria_id = aria_id
    @aria_controls = "#{@aria_id}-content"
    super(**attributes)
  end

  def default_attributes
    {
      role: "button",
      aria: {
        haspopup: "dialog",
        expanded: "false",
        controls: @aria_controls,
      },
      data: {
        action: "click->shadcn-phlexcomponents--alert-dialog#toggle",
        "shadcn-phlexcomponents--alert-dialog-target": "trigger",
      },
    }
  end

  def view_template(&)
    if @as_child
      content = capture(&)
      element = find_as_child(content.to_s)

      vanish(&)
      element_attributes = nokogiri_attributes_to_hash(element)
      merged_attributes = mix(@attributes, element_attributes)
      merged_attributes[:class] = TAILWIND_MERGER.merge("#{STYLES} #{element_attributes[:class]}")

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
