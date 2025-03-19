# frozen_string_literal: true

class Breadcrumb < BaseComponent
  STYLES = <<~HEREDOC
    flex flex-wrap items-center gap-1.5 break-words text-sm
    text-muted-foreground sm:gap-2.5
  HEREDOC

  def item(**attributes, &)
    render(BreadcrumbItem.new(**attributes, &))
  end

  def link(name = nil, options = nil, html_options = nil, &block)
    render(BreadcrumbLink.new(name, options, html_options, &block))
  end

  def separator(**attributes, &)
    render(BreadcrumbSeparator.new(**attributes, &))
  end

  def page(**attributes, &)
    render(BreadcrumbPage.new(**attributes, &))
  end

  def ellipsis(**attributes)
    render(BreadcrumbEllipsis.new(**attributes))
  end

  def links(links)
    @links = links

    @links.each_with_index do |link, index|
      if index == @links.size - 1
        render(BreadcrumbItem.new) do
          render(BreadcrumbPage.new { link[:name] })
        end
      else
        render(BreadcrumbItem.new) do
          render(BreadcrumbLink.new(link[:name], link[:path]))
        end
      end

      if index < @links.size - 1
        render(BreadcrumbSeparator.new)
      end
    end
  end

  def view_template(&)
    nav(aria: { label: "breadcrumb" }) do
      ol(**@attributes, &)
    end
  end
end
