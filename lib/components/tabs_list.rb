# frozen_string_literal: true

module ShadcnPhlexcomponents
  class TabsList < Base
    STYLES = <<~HEREDOC.freeze
      inline-flex h-9 items-center justify-center rounded-lg bg-muted p-1 text-muted-foreground outline-none
    HEREDOC

    def view_template(&)
      div(**@attributes, &)
    end

    def default_attributes
      {
        role: "tablist",
        tabindex: "-1",
        aria: {
          orientation: "horizontal"
        }
      }
    end
  end
end