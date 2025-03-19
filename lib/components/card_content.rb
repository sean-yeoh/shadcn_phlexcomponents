# frozen_string_literal: true

class CardContent < BaseComponent
  STYLES = "p-6 pt-0"

  def view_template(&)
    div(**@attributes, &)
  end
end
