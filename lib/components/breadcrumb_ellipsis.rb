# frozen_string_literal: true

class BreadcrumbEllipsis < BaseComponent
  STYLES = "flex h-9 w-9 items-center justify-center"

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
      lucide_icon("ellipsis", class: "size-4")
    end
  end
end
