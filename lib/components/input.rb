# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Input < Base
    STYLES = <<~HEREDOC
      flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1
      text-base shadow-sm transition-colors file:border-0 file:bg-transparent
      file:text-sm file:font-medium file:text-foreground placeholder:text-muted-foreground
      focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring
      disabled:cursor-not-allowed disabled:opacity-50 md:text-sm
    HEREDOC

    def initialize(type: :text, name: nil, id: nil, **attributes)
      @type = type
      @name = name
      @id = id || @name
      super(**attributes)
    end

    def default_attributes
      {
        type: @type,
        name: @name,
        id: @id,
      }
    end

    def view_template(&)
      input(**@attributes, &)
    end
  end
end