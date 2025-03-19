# frozen_string_literal: true

class BreadcrumbItem < BaseComponent
  STYLES = "inline-flex items-center gap-1.5"

  def view_template(&)
    li(**@attributes, &)
  end
end
