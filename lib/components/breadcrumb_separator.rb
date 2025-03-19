# frozen_string_literal: true

class BreadcrumbSeparator < BaseComponent
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
        lucide_icon("chevron-right")
      end
    end
  end
end
