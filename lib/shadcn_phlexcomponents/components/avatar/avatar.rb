# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Avatar < Base
    STYLES = "relative flex h-10 w-10 shrink-0 overflow-hidden rounded-full"

    def initialize(**attributes)
      super(**attributes)
    end

    def image(**attributes, &)
      AvatarImage(**attributes, &)
    end

    def fallback(**attributes, &)
      AvatarFallback(**attributes, &)
    end

    def default_attributes
      {
        data: {
          controller: "avatar",
        },
      }
    end

    def view_template(&)
      span(**@attributes, &)
    end
  end
end
