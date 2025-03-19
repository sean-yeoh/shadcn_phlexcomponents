# frozen_string_literal: true

class CardTitle < BaseComponent
  STYLES = "font-semibold leading-none tracking-tight"

  def view_template(&)
    div(**@attributes, &)
  end
end
