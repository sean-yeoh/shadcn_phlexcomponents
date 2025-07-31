# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Skeleton < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.skeleton ||
        {
          base: "bg-accent animate-pulse rounded-md",
        }
      ),
    )

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
