# frozen_string_literal: true

class Card < BaseComponent
  STYLES = "rounded-xl border bg-card text-card-foreground shadow"

  def header(**attributes, &)
    render(CardHeader.new(**attributes, &))
  end

  def title(**attributes, &)
    render(CardTitle.new(**attributes, &))
  end

  def description(**attributes, &)
    render(CardDescription.new(**attributes, &))
  end

  def content(**attributes, &)
    render(CardContent.new(**attributes, &))
  end

  def footer(**attributes, &)
    render(CardFooter.new(**attributes, &))
  end

  def view_template(&)
    div(**@attributes, &)
  end
end
