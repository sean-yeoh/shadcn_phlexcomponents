# frozen_string_literal: true

module ShadcnPhlexcomponents
  class DropdownMenuTrigger < Base
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
        id: "#{@aria_id}-trigger",
        role: "button",
        aria: {
          haspopup: "menu",
          expanded: false,
          controls: "#{@aria_id}-content",
        },
        data: {
          state: "closed",
          as_child: @as_child.to_s,
          action: <<~HEREDOC,
            click->dropdown-menu#toggle
            keydown.space->dropdown-menu#toggle
            keydown.enter->dropdown-menu#toggle
            keydown.down->dropdown-menu#toggle:prevent
          HEREDOC
          "dropdown-menu-target": "trigger",
        },
      }
    end
  end
end
