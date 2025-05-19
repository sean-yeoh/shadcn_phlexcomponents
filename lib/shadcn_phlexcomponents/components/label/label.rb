# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Label < Base
    STYLES = <<~HEREDOC
      text-sm font-medium leading-none peer-disabled:cursor-not-allowed
      peer-disabled:opacity-70 block
    HEREDOC

    def view_template(&)
      label(**@attributes, &)
    end
  end
end
