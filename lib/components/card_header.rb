# frozen_string_literal: true

class CardHeader < BaseComponent
  STYLES = "flex flex-col space-y-1.5 p-6"

  def view_template(&)
    div(**@attributes, &)
  end
end
