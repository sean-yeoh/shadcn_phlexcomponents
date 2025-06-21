# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Tooltip < Base
    class_variants(base: "inline-flex max-w-fit")

    def initialize(open: false, **attributes)
      @open = open
      @aria_id = "tooltip-#{SecureRandom.hex(5)}"
      super(**attributes)
    end

    def trigger(**attributes, &)
      TooltipTrigger(aria_id: @aria_id, **attributes, &)
    end

    def content(**attributes, &)
      TooltipContent(aria_id: @aria_id, **attributes, &)
    end

    def default_attributes
      {
        data: {
          controller: "tooltip",
          tooltip_is_open_value: @open.to_s,
        },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end

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
        aria: {
          describedby: "#{@aria_id}-content",
        },
        data: {
          as_child: @as_child.to_s,
          tooltip_target: "trigger",
          action: <<~HEREDOC,
            focus->tooltip#open
            blur->tooltip#closeImmediately
            click->tooltip#open
          HEREDOC
        },
      }
    end
  end

  class TooltipContent < Base
    class_variants(
      base: <<~HEREDOC,
        bg-primary text-primary-foreground animate-in fade-in-0 zoom-in-95 data-[state=closed]:animate-out
        data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95 data-[side=bottom]:slide-in-from-top-2
        data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2
        z-50 w-fit origin-(--radix-tooltip-content-transform-origin) rounded-md px-3 py-1.5 text-xs text-balance
      HEREDOC
    )

    def initialize(side: :top, align: :center, aria_id: nil, **attributes)
      @side = side
      @align = align
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      div(
        class: "hidden fixed top-0 left-0 w-max z-50",
        data: { tooltip_target: "contentContainer" },
      ) do
        div(**@attributes) do
          yield

          span(data: { tooltip_target: "arrow" }) do
            raw(safe(
              '<svg class="bg-primary fill-primary z-50 size-2.5 translate-y-[calc(-50%_-_2px)] rotate-45 rounded-[2px]" width="10" height="5" viewBox="0 0 30 10" preserveAspectRatio="none">
                <polygon points="0,0 30,0 15,10"></polygon>
              </svg>',
            ))
          end

          span(
            id: "#{@aria_id}-content",
            role: "tooltip",
            class: "sr-only",
            &
          )
        end
      end
    end

    def default_attributes
      {
        data: {
          side: @side,
          align: @align,
          tooltip_target: "content",
          action: "mouseover->tooltip#open mouseout->tooltip#close",
        },
      }
    end
  end
end
