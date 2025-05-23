# frozen_string_literal: true

module ShadcnPhlexcomponents
  class AlertDialog < Base
    STYLES = "inline-block max-w-fit"

    def initialize(aria_id: "alert-dialog-#{SecureRandom.hex(5)}", **attributes)
      @aria_id = aria_id
      super(**attributes)
    end

    def trigger(**attributes, &)
      AlertDialogTrigger(aria_id: @aria_id, **attributes, &)
    end

    def content(**attributes, &)
      AlertDialogContent(aria_id: @aria_id, **attributes, &)
    end

    def header(**attributes, &)
      AlertDialogHeader(**attributes, &)
    end

    def title(**attributes, &)
      AlertDialogTitle(aria_id: @aria_id, **attributes, &)
    end

    def description(**attributes, &)
      AlertDialogDescription(aria_id: @aria_id, **attributes, &)
    end

    def footer(**attributes, &)
      AlertDialogFooter(**attributes, &)
    end

    def cancel(**attributes, &)
      AlertDialogCancel(**attributes, &)
    end

    def action(**attributes, &)
      AlertDialogAction(**attributes, &)
    end

    def action_to(name = nil, options = nil, html_options = nil, &block)
      AlertDialogActionTo(name, options, html_options, &block)
    end

    def default_attributes
      {
        data: {
          controller: "alert-dialog",
        },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
