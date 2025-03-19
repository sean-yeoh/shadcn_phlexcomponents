# frozen_string_literal: true

class Label < BaseComponent
  STYLES = <<~HEREDOC
    text-sm font-medium leading-none peer-disabled:cursor-not-allowed
    peer-disabled:opacity-70 block
  HEREDOC

  def view_template(&)
    label(**@attributes, &)
  end
end
