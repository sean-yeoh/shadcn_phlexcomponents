# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Card < Base
    STYLES = "rounded-xl border bg-card text-card-foreground shadow"

    def header(**attributes, &)
      CardHeader(**attributes, &)
    end

    def title(**attributes, &)
      CardTitle(**attributes, &)
    end

    def description(**attributes, &)
      CardDescription(**attributes, &)
    end

    def content(**attributes, &)
      CardContent(**attributes, &)
    end

    def footer(**attributes, &)
      CardFooter(**attributes, &)
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end
end