# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Pagination < Base
    STYLES = "mx-auto flex w-full justify-center"

    def link(**attributes, &)
      PaginationLink(**attributes, &)
    end
    
    def previous(**attributes, &)
      PaginationPrevious(**attributes, &)
    end

    def next(**attributes, &)
      PaginationNext(**attributes, &)
    end
    
    def ellipsis(**attributes, &)
      PaginationEllipsis(**attributes, &)
    end

    def default_attributes
      {
        role: "navigation",
        aria: {
          label: "navigation",
        }
      }
    end

    def view_template(&)
      div(**@attributes) do
        ul(class: "flex flex-row items-center gap-1", &)
      end
    end
  end
end