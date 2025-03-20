# frozen_string_literal: true

class DialogHeader < BaseComponent
  STYLES = "flex flex-col space-y-1.5 text-center sm:text-left"

  def view_template(&)
    div(**@attributes, &)
  end
end
