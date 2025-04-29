# frozen_string_literal: true

module ShadcnPhlexcomponents
  class PaginationEllipsis < Base
    STYLES = "flex h-9 w-9 items-center justify-center"

    def default_attributes
      {
        aria: {
          hidden: "true",
        },
      }
    end

    def view_template
      li do
        span(**@attributes) do
          icon("ellipsis", class: "size-4")
          span(class: "sr-only") { "More pages" }
        end
      end
    end
  end
end
