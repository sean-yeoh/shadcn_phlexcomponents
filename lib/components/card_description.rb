# frozen_string_literal: true

class CardDescription < BaseComponent
  STYLES = "text-sm text-muted-foreground"

  def view_template(&)
    div(**@attributes, &)
  end
end
