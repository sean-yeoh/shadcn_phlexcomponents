# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Pagination < Base
    class_variants(base: "mx-auto flex w-full justify-center")

    def item(**attributes, &)
      PaginationItem(**attributes, &)
    end

    def link(name = nil, options = nil, html_options = nil, &)
      PaginationLink(name, options, html_options, &)
    end

    def previous(options = nil, html_options = nil)
      PaginationPrevious(options, html_options)
    end

    def next(options = nil, html_options = nil)
      PaginationNext(options, html_options)
    end

    def ellipsis(**attributes, &)
      PaginationEllipsis(**attributes, &)
    end

    def default_attributes
      {
        role: "navigation",
        aria: {
          label: "navigation",
        },
      }
    end

    def view_template(&)
      div(**@attributes) do
        ul(class: "flex flex-row items-center gap-1", &)
      end
    end
  end

  class PaginationItem < Base
    def view_template(&)
      li(**@attributes, &)
    end
  end

  class PaginationPrevious < Base
    class_variants(base: "gap-1 px-2.5 sm:pl-2.5")

    def initialize(options = nil, html_options = nil)
      @options = options
      @html_options = html_options
    end

    def default_attributes
      {
        aria: {
          label: "Go to previous page",
        },
      }
    end

    def view_template
      @html_options ||= {}
      @html_options = mix(default_attributes, @html_options)
      @html_options[:class] = class_variants(clase: @html_options[:class])
      @html_options[:size] = :default

      PaginationLink(@options, @html_options) do
        icon("chevron-left")
        span(class: "hidden sm:block") { "Previous" }
      end
    end
  end

  class PaginationNext < Base
    class_variants(base: "gap-1 px-2.5 sm:pr-2.5")

    def initialize(options = nil, html_options = nil)
      @options = options
      @html_options = html_options
    end

    def default_attributes
      {
        aria: {
          label: "Go to next page",
        },
      }
    end

    def view_template
      @html_options ||= {}
      @html_options = mix(default_attributes, @html_options)
      @html_options[:class] = class_variants(clase: @html_options[:class])
      @html_options[:size] = :default

      PaginationLink(@options, @html_options) do
        span(class: "hidden sm:block") { "Next" }
        icon("chevron-right")
      end
    end
  end

  class PaginationLink < Base
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
      @html_options = mix(default_attributes, @html_options)

      active = @html_options.delete(:active)
      size = @html_options.delete(:size)

      if active
        @html_options = mix({ aria: { current: "page" } }, @html_options)
      end

      @html_options[:class] = Button.new.class_variants(
        variant: active ? :outline : :ghost,
        size: size || :icon,
        class: @html_options[:class],
      )

      if block_given?
        li do
          link_to(@options, @html_options, &)
        end
      else
        li do
          link_to(@name, @options, @html_options)
        end
      end
    end
  end

  class PaginationEllipsis < Base
    class_variants(base: "flex size-9 items-center justify-center")

    def default_attributes
      {
        aria: {
          hidden: "true",
        },
      }
    end

    def view_template
      span(**@attributes) do
        icon("ellipsis", class: "size-4")
        span(class: "sr-only") { "More pages" }
      end
    end
  end
end
