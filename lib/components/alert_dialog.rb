# frozen_string_literal: true

class AlertDialog < BaseComponent
  STYLES = "inline-block"

  def initialize(aria_id: "alert-dialog-#{SecureRandom.hex(5)}", **attributes)
    @aria_id = aria_id
    super(**attributes)
  end

  def trigger(**attributes, &)
    render(AlertDialogTrigger.new(aria_id: @aria_id, **attributes, &))
  end

  def content(**attributes, &)
    render(AlertDialogContent.new(aria_id: @aria_id, **attributes, &))
  end

  def header(**attributes, &)
    render(AlertDialogHeader.new(**attributes, &))
  end

  def title(**attributes, &)
    render(AlertDialogTitle.new(aria_id: @aria_id, **attributes, &))
  end

  def description(**attributes, &)
    render(AlertDialogDescription.new(aria_id: @aria_id, **attributes, &))
  end

  def footer(**attributes, &)
    render(AlertDialogFooter.new(**attributes, &))
  end

  def cancel(**attributes, &)
    render(AlertDialogCancel.new(**attributes, &))
  end

  def action(**attributes, &)
    render(AlertDialogAction.new(**attributes, &))
  end

  def default_attributes
    {
      data: {
        controller: "shadcn-phlexcomponents--alert-dialog",
      },
    }
  end

  def view_template(&)
    div(**@attributes, &)
  end
end
