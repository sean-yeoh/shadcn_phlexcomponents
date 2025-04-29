# frozen_string_literal: true

module ShadcnPhlexcomponents
  class AvatarImage < Base
    STYLES = "aspect-square h-full w-full"

    def default_attributes
      {
        data: {
          "shadcn-phlexcomponents--avatar-target": "image",
        },
      }
    end

    def view_template(&)
      img(**@attributes, &)
    end
  end
end
