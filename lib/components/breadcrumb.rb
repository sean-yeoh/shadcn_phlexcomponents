# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Breadcrumb < Base
    STYLES = "flex flex-wrap items-center gap-1.5 break-words text-sm text-muted-foreground sm:gap-2.5"

    def item(**attributes, &)
      BreadcrumbItem(**attributes, &)
    end

    def link(name = nil, options = nil, html_options = nil, &block)
      BreadcrumbLink(name, options, html_options, &block)
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
    end

    def view_template(&)
      nav(aria: { label: "breadcrumb" }) do
        ol(**@attributes, &)
      end
    end
  end
end