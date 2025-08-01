# frozen_string_literal: true

module ShadcnPhlexcomponents
  class AlertDialog < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.alert_dialog&.dig(:root) ||
        {
          base: "inline-flex max-w-fit",
        }
      ),
    )

    def initialize(open: false, **attributes)
      @open = open
      @aria_id = "alert-dialog-#{SecureRandom.hex(5)}"
      super(**attributes)
    end

    def trigger(**attributes, &)
      AlertDialogTrigger(aria_id: @aria_id, **attributes, &)
    end

    def content(**attributes, &)
      AlertDialogContent(aria_id: @aria_id, **attributes, &)
    end

    def header(**attributes, &)
      AlertDialogHeader(**attributes, &)
    end

    def title(**attributes, &)
      AlertDialogTitle(aria_id: @aria_id, **attributes, &)
    end

    def description(**attributes, &)
      AlertDialogDescription(aria_id: @aria_id, **attributes, &)
    end

    def footer(**attributes, &)
      AlertDialogFooter(**attributes, &)
    end

    def cancel(**attributes, &)
      AlertDialogCancel(**attributes, &)
    end

    def action(**attributes, &)
      AlertDialogAction(**attributes, &)
    end

    def action_to(name = nil, options = nil, html_options = nil, &)
      AlertDialogActionTo(name, options, html_options, &)
    end

    def default_attributes
      {
        data: {
          controller: "alert-dialog",
          alert_dialog_is_open_value: @open.to_s,
        },
      }
    end

    def view_template(&)
      div(**@attributes) do
        overlay("alert-dialog")

        yield
      end
    end
  end

  class AlertDialogTrigger < Base
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
          alert_dialog_target: "trigger",
          action: "click->alert-dialog#open",
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

  class AlertDialogContent < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.alert_dialog&.dig(:content) ||
        {
          base: <<~HEREDOC,
            bg-background data-[state=open]:animate-in data-[state=closed]:animate-out
            data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95
            data-[state=open]:zoom-in-95 fixed top-[50%] left-[50%] z-50 grid w-full max-w-[calc(100%-2rem)]
            translate-x-[-50%] translate-y-[-50%] gap-4 rounded-lg border p-6 shadow-lg duration-200 sm:max-w-lg
            pointer-events-auto outline-none
          HEREDOC
        }
      ),
    )

    def initialize(aria_id: nil, **attributes)
      @aria_id = aria_id
      super(**attributes)
    end

    def default_attributes
      {
        id: "#{@aria_id}-content",
        tabindex: -1,
        role: "alertdialog",
        aria: {
          describedby: "#{@aria_id}-description",
          labelledby: "#{@aria_id}-title",
        },
        data: {
          state: "closed",
          alert_dialog_target: "content",
        },
      }
    end

    def view_template(&)
      div(style: { display: "none" }, **@attributes, &)
    end
  end

  class AlertDialogHeader < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.alert_dialog&.dig(:header) ||
        {
          base: "flex flex-col gap-2 text-center sm:text-left",
        }
      ),
    )

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class AlertDialogTitle < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.alert_dialog&.dig(:title) ||
        {
          base: "text-lg font-semibold",
        }
      ),
    )

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

  class AlertDialogDescription < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.alert_dialog&.dig(:description) ||
        {
          base: "text-sm text-muted-foreground",
        }
      ),
    )

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

  class AlertDialogFooter < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.alert_dialog&.dig(:footer) ||
        {
          base: "flex flex-col-reverse gap-2 sm:flex-row sm:justify-end",
        }
      ),
    )

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class AlertDialogCancel < Base
    def initialize(variant: :outline, size: :default, **attributes)
      @variant = variant
      @size = size
      super(**attributes)
    end

    def default_attributes
      {
        data: {
          action: "click->alert-dialog#close",
        },
      }
    end

    def view_template(&)
      Button(variant: @variant, size: @size, **@attributes, &)
    end
  end

  class AlertDialogAction < Base
    def initialize(variant: :default, size: :default, as_child: false, **attributes)
      @variant = variant
      @size = size
      @as_child = as_child
      super(**attributes)
    end

    def default_attributes
      {
        data: {
          action: "click->alert-dialog#close",
        },
      }
    end

    def class_variants(**args)
      Button.new.class_variants(variant: @variant, size: @size, class: args[:class])
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
        button(**@attributes, &)
      end
    end
  end

  class AlertDialogActionTo < AlertDialogAction
    def initialize(name = nil, options = nil, html_options = nil)
      @name = name
      @options = options
      @html_options = html_options
    end

    def view_template(&)
      if block_given?
        @html_options = @options
        @options = @name
      end

      @html_options ||= {}
      @variant = @html_options.delete(:variant) || :default
      @size = @html_options.delete(:size) || :default
      merge_default_attributes({})
      @html_options = mix(@attributes, @html_options)

      if block_given?
        button_to(@options, @html_options, &)
      else
        button_to(@name, @options, @html_options)
      end
    end
  end
end
