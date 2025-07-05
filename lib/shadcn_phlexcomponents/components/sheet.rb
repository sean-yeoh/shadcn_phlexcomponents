# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Sheet < Base
    class_variants(base: "inline-flex max-w-fit")

    def initialize(open: false, **attributes)
      @open = open
      @aria_id = "sheet-#{SecureRandom.hex(5)}"
      super(**attributes)
    end

    def trigger(**attributes, &)
      SheetTrigger(aria_id: @aria_id, **attributes, &)
    end

    def content(**attributes, &)
      SheetContent(aria_id: @aria_id, open: @open, **attributes, &)
    end

    def header(**attributes, &)
      SheetHeader(**attributes, &)
    end

    def title(**attributes, &)
      SheetTitle(aria_id: @aria_id, **attributes, &)
    end

    def description(**attributes, &)
      SheetDescription(aria_id: @aria_id, **attributes, &)
    end

    def footer(**attributes, &)
      SheetFooter(**attributes, &)
    end

    def close(**attributes, &)
      SheetClose(**attributes, &)
    end

    def default_attributes
      {
        data: {
          controller: "dialog",
          dialog_is_open_value: @open.to_s,
        },
      }
    end

    def view_template(&)
      div(**@attributes) do
        overlay("dialog")

        yield
      end
    end
  end

  class SheetTrigger < Base
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
          expanded: false,
          controls: "#{@aria_id}-content",
        },
        data: {
          as_child: @as_child.to_s,
          dialog_target: "trigger",
          action: "click->dialog#open",
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

  class SheetContent < Base
    class_variants(
      base: <<~HEREDOC,
        bg-background data-[state=open]:animate-in data-[state=closed]:animate-out fixed z-50 flex flex-col gap-4
        shadow-lg transition ease-in-out data-[state=closed]:duration-300 data-[state=open]:duration-500
        pointer-events-auto outline-none
      HEREDOC
      variants: {
        side: {
          top: "data-[state=closed]:slide-out-to-top data-[state=open]:slide-in-from-top inset-x-0 top-0 h-auto border-b",
          left: "h-screen data-[state=closed]:slide-out-to-left data-[state=open]:slide-in-from-left inset-y-0 left-0 w-3/4 border-r sm:max-w-sm",
          right: "h-screen data-[state=closed]:slide-out-to-right data-[state=open]:slide-in-from-right inset-y-0 right-0 w-3/4 border-l sm:max-w-sm",
          bottom: "data-[state=closed]:slide-out-to-bottom data-[state=open]:slide-in-from-bottom inset-x-0 bottom-0 h-auto border-t",
        },
      },
      defaults: {
        side: :right,
      },
    )

    def initialize(side: :right, open: false, aria_id: nil, **attributes)
      @class_variants = { side: side }
      @aria_id = aria_id
      @open = open
      super(**attributes)
    end

    def view_template(&)
      div(style: { display: "none" }, **@attributes) do
        yield

        button(
          class: <<~HEREDOC,
            ring-offset-background focus:ring-ring data-[state=open]:bg-secondary absolute top-4 right-4 rounded-xs
            opacity-70 transition-opacity hover:opacity-100 focus:ring-2 focus:ring-offset-2 focus:outline-hidden
            disabled:pointer-events-none
          HEREDOC
          data: { action: "click->dialog#close" },
        ) do
          icon("x", class: "size-4")
          span(class: "sr-only") { "close" }
        end
      end
    end

    def default_attributes
      {
        id: "#{@aria_id}-content",
        tabindex: -1,
        role: "dialog",
        aria: {
          describedby: "#{@aria_id}-description",
          labelledby: "#{@aria_id}-title",
        },
        data: {
          state: "closed",
          dialog_target: "content",
        },
      }
    end
  end

  class SheetHeader < Base
    class_variants(base: "flex flex-col gap-1.5 p-4")

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class SheetTitle < Base
    class_variants(base: "text-foreground font-semibold")

    def initialize(aria_id: nil, **attributes)
      @aria_id = aria_id
      super(**attributes)
    end

    def default_attributes
      {
        id: "#{@aria_id}-title",
      }
    end

    def view_template(&)
      h2(**@attributes, &)
    end
  end

  class SheetDescription < Base
    class_variants(base: "text-muted-foreground text-sm")

    def initialize(aria_id: nil, **attributes)
      @aria_id = aria_id
      super(**attributes)
    end

    def default_attributes
      {
        id: "#{@aria_id}-description",
      }
    end

    def view_template(&)
      p(**@attributes, &)
    end
  end

  class SheetFooter < Base
    class_variants(base: "mt-auto flex flex-col gap-2 p-4")

    def view_template(&)
      div(**@attributes, &)
    end
  end

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
        data: {
          action: "click->dialog#close",
        },
      }
    end
  end
end
