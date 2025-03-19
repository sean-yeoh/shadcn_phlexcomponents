# frozen_string_literal: true

class AlertTitle < BaseComponent
  STYLES = "mb-1 font-medium leading-none tracking-tight"

  def view_template(&)
    div(**@attributes, &)
  end
end
