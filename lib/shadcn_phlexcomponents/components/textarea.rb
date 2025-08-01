# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Textarea < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.textarea ||
        {
          base: <<~HEREDOC,
            border-input placeholder:text-muted-foreground focus-visible:border-ring focus-visible:ring-ring/50
            aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive
            dark:bg-input/30 flex field-sizing-content min-h-16 w-full rounded-md border bg-transparent px-3 py-2
            text-base shadow-xs transition-[color,box-shadow] outline-none focus-visible:ring-[3px]
            disabled:cursor-not-allowed disabled:opacity-50 md:text-sm
          HEREDOC
        }
      ),
    )

    def initialize(value: nil, **attributes)
      @value = value
      super(**attributes)
    end

    def view_template(&)
      textarea(**@attributes) { @value }
    end
  end
end
