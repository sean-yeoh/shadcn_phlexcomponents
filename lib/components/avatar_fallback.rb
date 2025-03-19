# frozen_string_literal: true

class AvatarFallback < BaseComponent
  STYLES = "flex h-full w-full items-center justify-center rounded-full bg-muted"

  def view_template(&)
    @class = @attributes.delete(:class)

    span(class: "#{@class} hidden", **@attributes, &)
  end

  def default_attributes
    {
      data: {
        "shadcn-phlexcomponents--avatar-target": "fallback",
      },
    }
  end
end
