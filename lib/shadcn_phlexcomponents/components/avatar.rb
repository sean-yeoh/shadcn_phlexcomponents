# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Avatar < Base
    class_variants(base: "relative flex size-8 shrink-0 overflow-hidden rounded-full")

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

  class AvatarImage < Base
    class_variants(base: "aspect-square size-full")

    def default_attributes
      {
        data: {
          avatar_target: "image",
        },
      }
    end

    def view_template(&)
      img(**@attributes, &)
    end
  end

  class AvatarFallback < Base
    class_variants(base: "bg-muted flex size-full items-center justify-center rounded-full")

    def default_attributes
      {
        data: {
          avatar_target: "fallback",
        },
      }
    end

    def view_template(&)
      span(**@attributes, &)
    end
  end
end
