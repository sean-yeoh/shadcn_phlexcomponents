# frozen_string_literal: true

class AvatarImage < BaseComponent
  STYLES = "aspect-square h-full w-full"

  def view_template(&)
    img(**@attributes, &)
  end

  def default_attributes
    {
      data: {
        "shadcn-phlexcomponents--avatar-target": "image",
      },
    }
  end
end
