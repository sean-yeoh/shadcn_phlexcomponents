# frozen_string_literal: true

module ShadcnPhlexcomponents
  class PaginationLink < Base
    def initialize(href: nil, active: false, **attributes)
      @href = href
      @active = active
      super(**attributes)
    end

    def default_styles
      if @active
        Button.default_styles(variant: :outline, size: :icon)
      else
        Button.default_styles(variant: :ghost, size: :icon)
      end
    end

    def default_attributes
      {
        href: @href,
        aria: {
          current: @active ? "page" : nil,
        },
      }
    end

    def view_template(&)
      li do
        a(**@attributes, &)
      end
    end
  end
end
