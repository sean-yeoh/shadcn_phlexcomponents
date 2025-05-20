# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Skeleton < Base
    STYLES = "animate-pulse rounded-md bg-primary/10"

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
