# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Popover < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.popover&.dig(:root) ||
        {
          base: "inline-flex max-w-fit",
        }
      ),
    )

    def initialize(open: false, **attributes)
      @open = open
      @aria_id = "popover-#{SecureRandom.hex(5)}"
      super(**attributes)
    end

    def trigger(**attributes, &)
      PopoverTrigger(aria_id: @aria_id, **attributes, &)
    end

    def content(**attributes, &)
      PopoverContent(aria_id: @aria_id, **attributes, &)
    end

    def default_attributes
      {
        data: {
          controller: "popover",
          popover_is_open_value: @open.to_s,
        },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class PopoverTrigger < Base
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
        merged_attributes = merged_as_child_attributes(element, @attributes)

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
        aria: {
          haspopup: "dialog",
          expanded: false,
          controls: "#{@aria_id}-content",
        },
        data: {
          as_child: @as_child.to_s,
          action: "click->popover#toggle",
          popover_target: "trigger",
        },
      }
    end
  end

  class PopoverContent < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.popover&.dig(:content) ||
        {
          base: <<~HEREDOC,
            bg-popover text-popover-foreground data-[state=open]:animate-in data-[state=closed]:animate-out
            data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95
            data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2
            data-[side=top]:slide-in-from-bottom-2 z-50 w-72 origin-(--radix-popper-transform-origin) rounded-md
            border p-4 shadow-md outline-hidden
          HEREDOC
        }
      ),
    )

    def initialize(side: :bottom, align: :center, aria_id: nil, **attributes)
      @side = side
      @align = align
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      PopoverContentContainer do
        div(**@attributes, &)
      end
    end

    def default_attributes
      {
        id: "#{@aria_id}-content",
        tabindex: -1,
        role: "dialog",
        data: {
          side: @side,
          align: @align,
          popover_target: "content",
          action: "popover:click:outside->popover#clickOutside",
        },
      }
    end
  end

  class PopoverContentContainer < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.popover&.dig(:content_container) ||
        {
          base: "fixed top-0 left-0 w-max z-50",
        }
      ),
    )

    def default_attributes
      {
        style: { display: "none" },
        data: { popover_target: "contentContainer" },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
