# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Collapsible < Base
    def initialize(open: false, **attributes)
      @open = open
      @aria_id = "collapsible-#{SecureRandom.hex(5)}"
      super(**attributes)
    end

    def trigger(**attributes, &)
      CollapsibleTrigger(aria_id: @aria_id, **attributes, &)
    end

    def content(**attributes, &)
      CollapsibleContent(aria_id: @aria_id, **attributes, &)
    end

    def default_attributes
      {
        data: {
          controller: "collapsible",
          collapsible_is_open_value: @open.to_s,
        },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class CollapsibleTrigger < Base
    def initialize(as_child: false, aria_id: nil, **attributes)
      @as_child = as_child
      @aria_id = aria_id
      super(**attributes)
    end

    def default_attributes
      {
        role: "button",
        aria: {
          expanded: "false",
          controls: "#{@aria_id}-content",
        },
        data: {
          state: "closed",
          action: "click->collapsible#toggle",
          collapsible_target: "trigger",
        },
      }
    end

    def view_template(&)
      if @as_child
        content = capture(&)
        element = find_as_child(content.to_s)
        vanish(&)
        merged_attributes = merged_as_child_attributes(element, @attributes)

        send(element.name, **merged_attributes) do
          sanitize_as_child(element.children.to_s)
        end
      else
        div(**@attributes, &)
      end
    end
  end

  class CollapsibleContent < Base
    def initialize(aria_id: :nil, **attributes)
      @aria_id = aria_id
      super(**attributes)
    end

    def default_attributes
      {
        id: "#{@aria_id}-content",
        data: {
          collapsible_target: "content",
        },
      }
    end

    def view_template(&)
      div(style: { display: "none" }, **@attributes, &)
    end
  end
end
