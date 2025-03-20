# frozen_string_literal: true

class AvatarImage < BaseComponent
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
