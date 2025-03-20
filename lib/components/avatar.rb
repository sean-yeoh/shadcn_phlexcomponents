# frozen_string_literal: true

class Avatar < BaseComponent
  STYLES = <<~HEREDOC
    relative flex h-10 w-10 shrink-0 overflow-hidden rounded-full
  HEREDOC

  def initialize(**attributes)
    super(**attributes)
  end

  def image(**attributes, &)
    render(AvatarImage.new(**attributes, &))
  end

  def fallback(**attributes, &)
    render(AvatarFallback.new(**attributes, &))
  end

  def default_attributes
    {
      data: {
        controller: "shadcn-phlexcomponents--avatar",
      },
    }
  end

  def view_template(&)
    span(**@attributes, &)
  end
end
