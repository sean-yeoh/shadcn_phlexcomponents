# frozen_string_literal: true

class CardFooter < BaseComponent
  STYLES = "flex items-center p-6 pt-0"

  def view_template(&)
    div(**@attributes, &)
  end
end
