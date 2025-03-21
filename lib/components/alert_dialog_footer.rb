# frozen_string_literal: true

class AlertDialogFooter < BaseComponent
  STYLES = "flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2"

  def view_template(&)
    div(**@attributes, &)
  end
end
