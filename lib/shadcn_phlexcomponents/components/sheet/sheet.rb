# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Sheet < Base
    STYLES = "inline-block max-w-fit"

    def initialize(side: :right, aria_id: "sheet-#{SecureRandom.hex(5)}", **attributes)
      @side = side
      @aria_id = aria_id
      super(**attributes)
    end

    def trigger(**attributes, &)
      SheetTrigger(aria_id: @aria_id, **attributes, &)
    end

    def content(**attributes, &)
      SheetContent(side: @side, aria_id: @aria_id, **attributes, &)
    end

    def header(**attributes, &)
      SheetHeader(**attributes, &)
    end

    def title(**attributes, &)
      SheetTitle(aria_id: @aria_id, **attributes, &)
    end

    def description(**attributes, &)
      SheetDescription(aria_id: @aria_id, **attributes, &)
    end

    def footer(**attributes, &)
      SheetFooter(**attributes, &)
    end

    def close(**attributes, &)
      SheetClose(**attributes, &)
    end

    def view_template(&)
      div(**@attributes, &)
    end

    def default_attributes
      {
        data: {
          controller: "dialog",
        },
      }
    end
  end
end
