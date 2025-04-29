# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Dialog < Base
    STYLES = "inline-block"

    def initialize(aria_id: "dialog-#{SecureRandom.hex(5)}", **attributes)
      @aria_id = aria_id
      super(**attributes)
    end

    def trigger(**attributes, &)
      render(DialogTrigger.new(aria_id: @aria_id, **attributes, &))
    end

    def content(**attributes, &)
      render(DialogContent.new(aria_id: @aria_id, **attributes, &))
    end

    def header(**attributes, &)
      render(DialogHeader.new(**attributes, &))
    end

    def title(**attributes, &)
      render(DialogTitle.new(aria_id: @aria_id, **attributes, &))
    end

    def description(**attributes, &)
      render(DialogDescription.new(aria_id: @aria_id, **attributes, &))
    end

    def footer(**attributes, &)
      render(DialogFooter.new(**attributes, &))
    end

    def close(**attributes, &)
      render(DialogClose.new(**attributes, &))
    end

    def default_attributes
      {
        data: {
          controller: "shadcn-phlexcomponents--dialog",
        },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
