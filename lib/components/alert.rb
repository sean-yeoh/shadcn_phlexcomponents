# frozen_string_literal: true

class Alert < BaseComponent
  STYLES = <<~HEREDOC
    relative w-full rounded-lg border px-4 py-3 text-sm [&>svg+div]:translate-y-[-3px]
    [&>svg]:absolute [&>svg]:left-4 [&>svg]:top-4 [&>svg~*]:pl-7
  HEREDOC

  VARIANTS = {
    default: "[&>svg]:text-foreground bg-background text-foreground",
    destructive: "border-destructive/50 text-destructive dark:border-destructive [&>svg]:text-destructive",
  }.freeze

  class << self
    def default_styles(variant)
      "#{STYLES} #{VARIANTS[variant]}"
    end
  end

  def initialize(variant: :default, **attributes)
    @variant = variant
    super(**attributes)
  end

  def title(**attributes, &)
    render(AlertTitle.new(**attributes, &))
  end

  def description(**attributes, &)
    render(AlertDescription.new(**attributes, &))
  end

  def default_attributes
    { role: "alert" }
  end

  def default_styles
    self.class.default_styles(@variant)
  end

  def view_template(&)
    div(**@attributes, &)
  end
end
