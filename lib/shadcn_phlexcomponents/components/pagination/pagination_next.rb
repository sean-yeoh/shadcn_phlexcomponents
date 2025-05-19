# frozen_string_literal: true

module ShadcnPhlexcomponents
  class PaginationNext < Base
    def initialize(href: nil, **attributes)
      @href = href
      super(**attributes)
    end

    def default_styles
      "#{Button.default_styles(variant: :ghost, size: :default)} gap-1 pr-2.5"
    end

    def default_attributes
      {
        href: @href,
        aria: {
          label: "Go to next page",
        },
      }
    end

    def view_template(&)
      li do
        a(**@attributes) do
          span { "Next" }
          icon("chevron-right", class: "size-4")
        end
      end
    end
  end
end
