# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Alert < Base
    STYLES = <<~HEREDOC
      relative w-full rounded-lg border px-4 py-3 text-sm [&>svg+div]:translate-y-[-3px]
      [&>svg]:absolute [&>svg]:left-4 [&>svg]:top-4 [&>svg]:text-foreground [&>svg~*]:pl-7
    HEREDOC

    VARIANTS = {
      default: "bg-background text-foreground",
      destructive: "border-destructive/50 text-destructive dark:border-destructive [&>svg]:text-destructive",
    }.freeze

    def initialize(variant: :default, **attributes)
      @variant = variant
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

    def default_styles
      "#{STYLES} #{VARIANTS[@variant]}"
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
