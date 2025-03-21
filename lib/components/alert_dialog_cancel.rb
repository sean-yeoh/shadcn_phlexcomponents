# frozen_string_literal: true

class AlertDialogClose < BaseComponent
  def default_attributes
    {
      data: {
        action: "click->shadcn-phlexcomponents--alert-dialog#close",
      },
    }
  end

  def view_template(&)
    render(Button.new(variant: :secondary, **@attributes, &))
  end
end
