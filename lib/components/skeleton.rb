# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Skeleton < Base
    STYLES = "animate-pulse rounded-md bg-primary/10".freeze

    def view_template(&)
      div(**@attributes, &)
    end
  end
end