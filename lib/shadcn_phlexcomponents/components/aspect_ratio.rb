# frozen_string_literal: true

module ShadcnPhlexcomponents
  class AspectRatio < Base
    class_variants(base: "absolute inset-0")

    def initialize(ratio: "1/1", **attributes)
      ratio_arr = ratio.split("/").map(&:to_f)
      @ratio = ratio_arr[0] / ratio_arr[1]
      super(**attributes)
    end

    def view_template(&)
      div(class: "relative w-full", style: { "padding-bottom": "#{100 / @ratio}%" }) do
        div(**@attributes, &)
      end
    end
  end
end
