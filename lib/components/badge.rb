# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Badge < Base
    STYLES = <<~HEREDOC
      inline-flex items-center rounded-md border px-2.5 py-0.5 text-xs font-semibold
      transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2
    HEREDOC

    VARIANTS = {
      primary: "border-transparent bg-primary text-primary-foreground shadow hover:bg-primary/80",
      secondary: "border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80",
      destructive: "border-transparent bg-destructive text-destructive-foreground shadow hover:bg-destructive/80",
      outline: "text-foreground",
    }.freeze

    class << self
      def default_styles(variant)
        "#{STYLES} #{VARIANTS[variant]}"
      end
    end

    def initialize(variant: :primary, **attributes)
      @variant = variant
      super(**attributes)
    end

    def default_styles
      self.class.default_styles(@variant)
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end
end