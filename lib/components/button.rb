# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Button < Base
    STYLES = <<~HEREDOC
      inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md
      text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1
      focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50
      [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 cursor-pointer
    HEREDOC

    VARIANTS = {
      primary: "bg-primary text-primary-foreground shadow hover:bg-primary/90",
      secondary: "bg-secondary text-secondary-foreground shadow-sm hover:bg-secondary/80",
      destructive: "bg-destructive text-destructive-foreground shadow-sm hover:bg-destructive/90",
      outline: "border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground",
      ghost: "hover:bg-accent hover:text-accent-foreground",
      link: "text-primary underline-offset-4 hover:underline",
    }.freeze

    SIZES = {
      default: "h-9 px-4 py-2",
      sm: "h-8 rounded-md px-3 text-xs",
      lg: "h-10 rounded-md px-8",
      icon: "h-9 w-9",
    }

    class << self
      def default_styles(variant:, size:)
        "#{STYLES} #{VARIANTS[variant]} #{SIZES[size]}"
      end
    end

    def initialize(variant: :primary, size: :default, type: :button, **attributes)
      @type = type
      @variant = variant
      @size = size
      super(**attributes)
    end

    def default_attributes
      { type: @type }
    end

    def default_styles
      self.class.default_styles(variant: @variant, size: @size)
    end

    def view_template(&)
      button(**@attributes, &)
    end
  end
end