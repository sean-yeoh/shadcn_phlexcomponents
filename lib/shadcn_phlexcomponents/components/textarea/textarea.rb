# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Textarea < Base
    STYLES = <<~HEREDOC
      flex min-h-[60px] w-full rounded-md border border-input bg-transparent px-3
      py-2 text-base shadow-sm placeholder:text-muted-foreground focus-visible:outline-none
      focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50 md:text-sm
    HEREDOC

    def initialize(name: nil, id: nil, value: nil, **attributes)
      @name = name
      @id = id || @name
      @value = value
      super(**attributes)
    end

    def default_attributes
      {
        name: @name,
        id: @id,
      }
    end

    def view_template(&)
      textarea(**@attributes) { @value }
    end
  end
end
