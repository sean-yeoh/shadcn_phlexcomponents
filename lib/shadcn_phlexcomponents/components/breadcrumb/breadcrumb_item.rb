# frozen_string_literal: true

module ShadcnPhlexcomponents
  class BreadcrumbItem < Base
    STYLES = "inline-flex items-center gap-1.5"

    def view_template(&)
      li(**@attributes, &)
    end
  end
end
