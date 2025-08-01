# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Toast < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.toast&.dig(:root) ||
        {
          base: <<~HEREDOC,
            p-4 border shadow-lg text-[0.8rem] flex gap-1.5 items-center w-full sm:w-90 rounded-lg duration-200
            data-[state=open]:animate-in data-[state=closed]:animate-out [&_svg]:size-4 [&_svg]:mr-1 [&_svg]:self-start [&_svg]:translate-y-0.5
          HEREDOC
          variants: {
            variant: {
              default: "bg-popover text-popover-foreground",
              destructive: "bg-card text-destructive [&>svg]:text-current *:data-[shadcn-phlexcomponents=toast-description]:text-destructive/90",
            },
            side: {
              top: "data-[state=closed]:slide-out-to-top data-[state=open]:slide-in-from-top",
              bottom: "data-[state=closed]:slide-out-to-bottom data-[state=open]:slide-in-from-bottom",
            },
          },
          defaults: {
            variant: :default,
          },
        }
      ),
    )

    def initialize(variant: :default, side: :top, duration: 5000, **attributes)
      @class_variants = { variant: variant, side: side }
      @duration = duration
      super(**attributes)
    end

    def content(**attributes, &)
      ToastContent(**attributes, &)
    end

    def title(**attributes, &)
      ToastTitle(**attributes, &)
    end

    def description(**attributes, &)
      ToastDescription(**attributes, &)
    end

    def action(**attributes, &)
      ToastAction(**attributes, &)
    end

    def action_to(name = nil, options = nil, html_options = nil, &)
      ToastActionTo(name, options, html_options, &)
    end

    def default_attributes
      {
        role: "status",
        tabindex: 0,
        aria: {
          live: "off",
          atomic: "true",
        },
        data: {
          duration: @duration,
          state: "open",
          controller: "toast",
          action: <<~HEREDOC,
            focus->toast#cancelClose
            blur->toast#close
            mouseover->toast#cancelClose
            mouseout->toast#close
          HEREDOC
        },
      }
    end

    def view_template(&)
      li(**@attributes, &)
    end
  end

  class ToastContent < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.toast&.dig(:content) ||
        {
          base: "flex flex-col gap-0.5",
        }
      ),
    )

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class ToastTitle < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.toast&.dig(:title) ||
        {
          base: "font-medium leading-[1.5]",
        }
      ),
    )

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class ToastDescription < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.toast&.dig(:description) ||
        {
          base: "leading-[1.4] opacity-90",
        }
      ),
    )

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class ToastAction < Base
    def initialize(as_child: false, **attributes)
      @as_child = as_child
      super(**attributes)
    end

    def class_variants(**args)
      Button.new.class_variants(variant: :default, size: :sm, class: "text-xs h-6 py-0 px-2 rounded-sm ml-auto #{args[:class]}")
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

  class ToastActionTo < ToastAction
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

      merge_default_attributes({})
      @html_options ||= {}
      @html_options = mix(@attributes, @html_options)
      @html_options[:form_class] = TAILWIND_MERGER.merge("inline-flex ml-auto #{@html_options[:form_class]}")

      if block_given?
        button_to(@options, @html_options, &)
      else
        button_to(@name, @options, @html_options)
      end
    end
  end
end
