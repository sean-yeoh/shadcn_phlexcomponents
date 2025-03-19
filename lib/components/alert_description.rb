# frozen_string_literal: true

class AlertDescription < BaseComponent
  STYLES = "text-sm [&_p]:leading-relaxed"

  def view_template(&)
    div(**@attributes, &)
  end
end
