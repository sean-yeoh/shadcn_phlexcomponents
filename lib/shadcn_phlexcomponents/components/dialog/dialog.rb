# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Dialog < Base
    STYLES = "inline-block max-w-fit"

    def initialize(aria_id: "dialog-#{SecureRandom.hex(5)}", **attributes)
      @aria_id = aria_id
      super(**attributes)
    end

    def trigger(**attributes, &)
      DialogTrigger(aria_id: @aria_id, **attributes, &)
    end

    def content(**attributes, &)
      DialogContent(aria_id: @aria_id, **attributes, &)
    end

    def header(**attributes, &)
      DialogHeader(**attributes, &)
    end

    def title(**attributes, &)
      DialogTitle(aria_id: @aria_id, **attributes, &)
    end

    def description(**attributes, &)
      DialogDescription(aria_id: @aria_id, **attributes, &)
    end

    def footer(**attributes, &)
      DialogFooter(**attributes, &)
    end

    def close(**attributes, &)
      DialogClose(**attributes, &)
    end

    def default_attributes
      {
        data: {
          controller: "dialog",
        },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
