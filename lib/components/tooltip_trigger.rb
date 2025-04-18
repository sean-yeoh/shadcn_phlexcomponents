# frozen_string_literal: true

module ShadcnPhlexcomponents
  class TooltipTrigger < Base
    def initialize(as_child: false, aria_id: nil, **attributes)
      @as_child = as_child
      @aria_id = aria_id
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

        send(element.name, **merged_attributes) do        
          sanitize_as_child(element.children.to_s)
        end
      else
        div(**@attributes, &)
      end
    end

    def default_attributes
      {
        id: @id,
        role: "button",
        aria: {
          describedby: "#{@aria_id}-content"
        },
        data: {
          as_child: @as_child.to_s,
          state: "closed",
          action: <<~HEREDOC,
            click->shadcn-phlexcomponents--tooltip#toggle
            mouseover->shadcn-phlexcomponents--tooltip#openWithDelay
            mouseout->shadcn-phlexcomponents--tooltip#closeWithDelay
          HEREDOC
          "shadcn-phlexcomponents--tooltip-target": "trigger"
        }
      }
    end
  end
end