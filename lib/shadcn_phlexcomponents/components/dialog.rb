# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Dialog < Base
    class_variants(base: "inline-flex max-w-fit")

    def initialize(open: false, **attributes)
      @open = open
      @aria_id = "dialog-#{SecureRandom.hex(5)}"
      super(**attributes)
    end

    def trigger(**attributes, &)
      DialogTrigger(aria_id: @aria_id, **attributes, &)
    end

    def content(**attributes, &)
      DialogContent(open: @open, aria_id: @aria_id, **attributes, &)
    end

    def header(**attributes, &)
      DialogHeader(**attributes, &)
    end

    def title(**attributes, &)
      DialogTitle(aria_id: @aria_id, **attributes, &)
    end

    def description(**attributes, &)
      DialogDescription(aria_id: @aria_id, **attributes, &)
    end

    def footer(**attributes, &)
      DialogFooter(**attributes, &)
    end

    def close(**attributes, &)
      DialogClose(**attributes, &)
    end

    def default_attributes
      {
        data: {
          controller: "dialog",
          dialog_is_open_value: @open.to_s
        }
      }
    end

    def view_template(&)
      div(**@attributes) do
        overlay("dialog")
        
        yield
      end
    end
  end

  class DialogTrigger < Base
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
          expanded: "false",
          controls: "#{@aria_id}-content",
        },
        data: { 
          as_child: @as_child.to_s,
          dialog_target: "trigger",
          action: "click->dialog#open"
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

  class DialogContent < Base
    class_variants(
      base: <<~HEREDOC,
        bg-background data-[state=open]:animate-in data-[state=closed]:animate-out
        data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95
        data-[state=open]:zoom-in-95 fixed top-[50%] left-[50%] z-50 grid w-full max-w-[calc(100%-2rem)]
        translate-x-[-50%] translate-y-[-50%] gap-4 rounded-lg border p-6 shadow-lg duration-200 sm:max-w-lg
        pointer-events-auto outline-none
      HEREDOC
    )

    def initialize(open: false, aria_id: nil, **attributes)
      @open = open
      @aria_id = aria_id
      super(**attributes)
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
          dialog_target: "content"
        },
      }
    end

    def view_template(&)
      div(style: { display: "none" }, **@attributes) do
        yield

        button(
          class: <<~HEREDOC,
            ring-offset-background focus:ring-ring data-[state=open]:bg-accent data-[state=open]:text-muted-foreground
            absolute top-4 right-4 rounded-xs opacity-70 transition-opacity hover:opacity-100 focus:ring-2
            focus:ring-offset-2 focus:outline-hidden disabled:pointer-events-none [&_svg]:pointer-events-none
            [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4
          HEREDOC
          data: {
            action: "click->dialog#close",
          },
        ) do
          icon("x", class: "size-4")
          span(class: "sr-only") { "close" }
        end
      end
    end
  end

  class DialogHeader < Base
    class_variants(base: "flex flex-col gap-2 text-center sm:text-left")

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class DialogTitle < Base
    class_variants(base: "text-lg leading-none font-semibold")

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

  class DialogDescription < Base
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

  class DialogFooter < Base
    class_variants(base: "flex flex-col-reverse gap-2 sm:flex-row sm:justify-end")

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class DialogClose < Base
    def initialize(as_child: false, **attributes)
      @as_child = as_child
      super(**attributes)
    end

    def default_attributes
      {
        role: "button",
        data: {
          action: "click->dialog#close",
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
end
