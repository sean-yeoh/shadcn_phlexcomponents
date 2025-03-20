# frozen_string_literal: true

class DialogClose < BaseComponent
  STYLES = "flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2"

  def initialize(as_child: false, **attributes)
    @as_child = as_child
    super(**attributes)
  end

  def default_attributes
    {
      role: "button",
      data: {
        action: "click->shadcn-phlexcomponents--dialog#close",
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
