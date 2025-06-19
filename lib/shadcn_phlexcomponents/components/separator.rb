# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Separator < Base
    class_variants(
      base: <<~HEREDOC,
        bg-border shrink-0 data-[orientation=horizontal]:h-px data-[orientation=horizontal]:w-full
        data-[orientation=vertical]:h-full data-[orientation=vertical]:w-px
      HEREDOC
    )

    def initialize(orientation: :horizontal, **attributes)
      @orientation = orientation
      super(**attributes)
    end

    def default_attributes
      {
        role: "none",
        data: {
          orientation: @orientation,
        },
      }
    end

    def view_template
      div(**@attributes)
    end
  end
end
