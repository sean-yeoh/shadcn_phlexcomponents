# frozen_string_literal: true

module ShadcnPhlexcomponents
  class BreadcrumbEllipsis < Base
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
        icon("ellipsis", class: "size-4")
        span(class: "sr-only") { "More" }
      end
    end
  end
end