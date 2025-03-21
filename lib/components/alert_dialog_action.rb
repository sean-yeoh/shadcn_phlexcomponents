# frozen_string_literal: true

class AlertDialogAction < BaseComponent
  def view_template(&)
    render(Button.new(**@attributes, &))
  end
end
