# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Alert < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.alert&.dig(:root) ||
        {
          base: <<~HEREDOC,
            relative w-full rounded-lg border px-4 py-3 text-sm grid has-[>svg]:grid-cols-[calc(var(--spacing)*4)_1fr]
            grid-cols-[0_1fr] has-[>svg]:gap-x-3 gap-y-0.5 items-start [&>svg]:size-4 [&>svg]:translate-y-0.5
            [&>svg]:text-current
          HEREDOC
          variants: {
            variant: {
              default: "bg-card text-card-foreground",
              destructive: "text-destructive bg-card [&>svg]:text-current *:data-[shadcn-phlexcomponents=alert-description]:text-destructive/90",
            },
          },
          defaults: {
            variant: :default,
          },
        }
      ),
    )

    def initialize(variant: :default, **attributes)
      @class_variants = { variant: variant }
      super(**attributes)
    end

    def title(**attributes, &)
      AlertTitle(**attributes, &)
    end

    def description(**attributes, &)
      AlertDescription(**attributes, &)
    end

    def default_attributes
      { role: "alert" }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class AlertTitle < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.alert&.dig(:title) ||
        {
          base: "col-start-2 line-clamp-1 min-h-4 font-medium tracking-tight",
        }
      ),
    )

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class AlertDescription < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.alert&.dig(:description) ||
        {
          base: "text-muted-foreground col-start-2 grid justify-items-start gap-1 text-sm [&_p]:leading-relaxed",
        }
      ),
    )

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
