# frozen_string_literal: true

class AspectRatio < BaseComponent
  STYLES = "absolute inset-0"

  def initialize(aspect_ratio: "1/1", **attributes)
    aspect_ratio_arr = aspect_ratio.split("/").map(&:to_f)
    @aspect_ratio = aspect_ratio_arr[0] / aspect_ratio_arr[1]
    super(**attributes)
  end

  def view_template(&)
    div(style: { position: "relative", width: "100%", "padding-bottom": "#{100 / @aspect_ratio}%" }) do
      div(**@attributes, &)
    end
  end
end
