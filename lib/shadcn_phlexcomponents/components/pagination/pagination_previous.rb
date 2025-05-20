# frozen_string_literal: true

module ShadcnPhlexcomponents
  class PaginationPrevious < Base
    def initialize(href: nil, **attributes)
      @href = href
      super(**attributes)
    end

    def default_attributes
      {
        href: @href,
        aria: {
          label: "Go to previous page",
        },
      }
    end

    def default_styles
      "#{Button.default_styles(variant: :ghost, size: :default)} gap-1 pl-2.5"
    end

    def view_template(&)
      li do
        a(**@attributes) do
          icon("chevron-left", class: "size-4")
          span { "Previous" }
        end
      end
    end
  end
end
