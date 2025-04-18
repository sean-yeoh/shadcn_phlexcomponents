# frozen_string_literal: true

module ShadcnPhlexcomponents
  class AvatarFallback < Base
    STYLES = "flex h-full w-full items-center justify-center rounded-full bg-muted"

    def default_attributes
      {
        data: {
          "shadcn-phlexcomponents--avatar-target": "fallback",
        },
      }
    end

    def view_template(&)
      @class = @attributes.delete(:class)

      span(class: "#{@class} hidden", **@attributes, &)
    end
  end
end