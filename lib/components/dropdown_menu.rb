# frozen_string_literal: true

module ShadcnPhlexcomponents
  class DropdownMenu < Base
    STYLES = "inline-block".freeze

    def initialize(side: :bottom, aria_id: "dropdown-menu-#{SecureRandom.hex(5)}", **attributes)
      @side = side
      @aria_id = aria_id
      super(**attributes)
    end

    def trigger(**attributes, &)
      DropdownMenuTrigger(aria_id: @aria_id, **attributes, &)
    end

    def content(**attributes, &)
      DropdownMenuContent(aria_id: @aria_id, side: @side, **attributes, &)
    end 

    def label(**attributes, &)
      DropdownMenuLabel(**attributes, &)
    end

    def item(**attributes, &)
      DropdownMenuItem(**attributes, &)
    end

    def item_to(name = nil, options = nil, html_options = nil, &block)
      DropdownMenuItemTo(name, options, html_options, &block)
    end

    def separator(**attributes, &)
      DropdownMenuSeparator(**attributes, &)
    end

    def default_attributes
      {
        data: {
          controller: "shadcn-phlexcomponents--dropdown-menu",
          side: @side
        }
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end
end