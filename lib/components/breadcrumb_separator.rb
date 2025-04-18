# frozen_string_literal: true

module ShadcnPhlexcomponents
  class BreadcrumbSeparator < Base
    STYLES = "[&>svg]:w-3.5 [&>svg]:h-3.5"

    def default_attributes
      {
        role: "presentation",
        aria: {
          hidden: "true",
        },
      }
    end

    def view_template(&)
      li(**@attributes) do
        if block_given?
          yield
        else
          icon("chevron-right")
        end
      end
    end
  end
end