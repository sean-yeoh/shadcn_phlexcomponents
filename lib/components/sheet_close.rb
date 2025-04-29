# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SheetClose < Base
    def initialize(as_child: false, **attributes)
      @as_child = as_child
      super(**attributes)
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

    def default_attributes
      {
        role: "button",
        data: {
          action: "click->shadcn-phlexcomponents--sheet#close",
        },
      }
    end
  end
end
