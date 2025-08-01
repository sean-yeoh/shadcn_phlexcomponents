# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Breadcrumb < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.breadcrumb&.dig(:root) ||
        {
          base: "text-muted-foreground flex flex-wrap items-center gap-1.5 text-sm break-words sm:gap-2.5",
        }
      ),
    )

    def item(**attributes, &)
      BreadcrumbItem(**attributes, &)
    end

    def link(name = nil, options = nil, html_options = nil, &)
      BreadcrumbLink(name, options, html_options, &)
    end

    def separator(**attributes, &)
      BreadcrumbSeparator(**attributes, &)
    end

    def page(**attributes, &)
      BreadcrumbPage(**attributes, &)
    end

    def ellipsis(**attributes)
      BreadcrumbEllipsis(**attributes)
    end

    def links(collection)
      collection.each_with_index do |link, index|
        if index == collection.size - 1
          item do
            page { link[:name] }
          end
        else
          item do
            link(link[:name], link[:path])
          end
        end

        if index < collection.size - 1
          separator
        end
      end

      nil
    end

    def view_template(&)
      nav(aria: { label: "breadcrumb" }) do
        ol(**@attributes, &)
      end
    end
  end

  class BreadcrumbItem < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.breadcrumb&.dig(:item) ||
        {
          base: "inline-flex items-center gap-1.5",
        }
      ),
    )

    def view_template(&)
      li(**@attributes, &)
    end
  end

  class BreadcrumbLink < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.breadcrumb&.dig(:link) ||
        {
          base: "transition-colors hover:text-foreground",
        }
      ),
    )

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
      @html_options[:class] = class_variants(class: @html_options[:class])

      if block_given?
        link_to(@options, @html_options, &)
      else
        link_to(@name, @options, @html_options)
      end
    end
  end

  class BreadcrumbSeparator < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.breadcrumb&.dig(:separator) ||
        {
          base: "[&>svg]:size-3.5",
        }
      ),
    )

    def default_attributes
      {
        role: "presentation",
        aria: {
          hidden: "true",
        },
      }
    end

    def view_template(&)
      li(**@attributes) do
        if block_given?
          yield
        else
          icon("chevron-right")
        end
      end
    end
  end

  class BreadcrumbPage < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.breadcrumb&.dig(:page) ||
        {
          base: "font-normal text-foreground",
        }
      ),
    )

    def default_attributes
      {
        role: "link",
        aria: {
          disabled: "true",
          current: "page",
        },
      }
    end

    def view_template(&)
      span(**@attributes, &)
    end
  end

  class BreadcrumbEllipsis < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.breadcrumb&.dig(:ellipsis) ||
        {
          base: "flex size-9 items-center justify-center",
        }
      ),
    )

    def default_attributes
      {
        role: "presentation",
        aria: {
          hidden: "true",
        },
      }
    end

    def view_template
      span(**@attributes) do
        icon("ellipsis", class: "size-4")
        span(class: "sr-only") { "More" }
      end
    end
  end
end
