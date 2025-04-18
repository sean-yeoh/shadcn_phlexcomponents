# frozen_string_literal: true

module ShadcnPhlexcomponents
  class BreadcrumbPage < Base
    STYLES = "font-normal text-foreground"

    def default_attributes
      {
        role: "link",
        aria: {
          disabled: "true",
          current: "page",
        },
      }
    end

    def view_template(&)
      span(**@attributes, &)
    end
  end
end