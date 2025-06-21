# frozen_string_literal: true

module ShadcnPhlexcomponents
  class HoverCard < Base
    class_variants(base: "inline-flex max-w-fit")

    def initialize(open: false, **attributes)
      @open = open
      super(**attributes)
    end

    def content(**attributes, &)
      HoverCardContent(**attributes, &)
    end

    def trigger(**attributes, &)
      HoverCardTrigger(**attributes, &)
    end

    def default_attributes
      {
        data: {
          controller: "hover-card",
          hover_card_is_open_value: @open.to_s,
        },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class HoverCardTrigger < Base
    def initialize(as_child: false, **attributes)
      @as_child = as_child
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
        id: @id,
        role: "button",
        data: {
          as_child: @as_child.to_s,
          hover_card_target: "trigger",
          action: <<~HEREDOC,
            focus->hover-card#open
            blur->hover-card#close
            click->hover-card#open
          HEREDOC
        },
      }
    end
  end

  class HoverCardContent < Base
    class_variants(
      base: <<~HEREDOC,
        bg-popover text-popover-foreground data-[state=open]:animate-in data-[state=closed]:animate-out
        data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95
        data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2
        data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 z-50 w-64
        origin-(--radix-popper-transform-origin) rounded-md border p-4 shadow-md outline-hidden
      HEREDOC
    )

    def initialize(side: :bottom, align: :center, **attributes)
      @side = side
      @align = align
      super(**attributes)
    end

    def view_template(&)
      div(
        class: "hidden fixed top-0 left-0 w-max z-50",
        data: { hover_card_target: "contentContainer" },
      ) do
        div(**@attributes, &)
      end
    end

    def default_attributes
      {
        tabindex: -1,
        data: {
          side: @side,
          align: @align,
          hover_card_target: "content",
          action: "mouseover->hover-card#open mouseout->hover-card#close",
        },
      }
    end
  end
end
