# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Card < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.card&.dig(:root) ||
        {
          base: "bg-card text-card-foreground flex flex-col gap-6 rounded-xl border py-6 shadow-sm",
        }
      ),
    )

    def header(**attributes, &)
      CardHeader(**attributes, &)
    end

    def title(**attributes, &)
      CardTitle(**attributes, &)
    end

    def description(**attributes, &)
      CardDescription(**attributes, &)
    end

    def action(**attributes, &)
      CardAction(**attributes, &)
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

  class CardHeader < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.card&.dig(:header) ||
        {
          base: <<~HEREDOC,
            @container/card-header grid auto-rows-min grid-rows-[auto_auto] items-start gap-1.5
            px-6 has-data-[shadcn-phlexcomponents=card-action]:grid-cols-[1fr_auto] [.border-b]:pb-6
          HEREDOC
        }
      ),
    )

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class CardTitle < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.card&.dig(:title) ||
        {
          base: "leading-none font-semibold",
        }
      ),
    )

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class CardDescription < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.card&.dig(:description) ||
        {
          base: "text-muted-foreground text-sm",
        }
      ),
    )

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class CardAction < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.card&.dig(:action) ||
        {
          base: "col-start-2 row-span-2 row-start-1 self-start justify-self-end",
        }
      ),
    )

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class CardContent < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.card&.dig(:content) ||
        {
          base: "px-6",
        }
      ),
    )

    class_variants(base: "")

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class CardFooter < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.card&.dig(:footer) ||
        {
          base: "flex items-center px-6 [.border-t]:pt-6",
        }
      ),
    )

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
