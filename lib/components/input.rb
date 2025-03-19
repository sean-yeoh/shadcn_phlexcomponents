# frozen_string_literal: true

class Input < BaseComponent
  STYLES = <<~HEREDOC
    flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1
    text-base shadow-sm transition-colors file:border-0 file:bg-transparent
    file:text-sm file:font-medium file:text-foreground placeholder:text-muted-foreground
    focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring
    disabled:cursor-not-allowed disabled:opacity-50 md:text-sm
    file:pt-0.5
  HEREDOC

  def initialize(type: :text, id: nil, **attributes)
    @type = type
    @id = id || attributes[:name]
    super(**attributes)
  end

  def view_template(&)
    input(**@attributes, &)
  end

  def default_attributes
    {
      type: @type,
      id: @id,
    }
  end
end
