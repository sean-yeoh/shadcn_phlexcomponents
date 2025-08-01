# frozen_string_literal: true

module ShadcnPhlexcomponents
  class AspectRatio < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.aspect_ratio&.dig(:root) ||
        {
          base: "absolute inset-0",
        }
      ),
    )

    def initialize(ratio: "1/1", **attributes)
      ratio_arr = ratio.split("/").map(&:to_f)
      @ratio = ratio_arr[0] / ratio_arr[1]
      super(**attributes)
    end

    def view_template(&)
      AspectRatioContainer(ratio: @ratio) do
        div(**@attributes, &)
      end
    end
  end

  class AspectRatioContainer < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.aspect_ratio&.dig(:container) ||
        {
          base: "relative w-full",
        }
      ),
    )

    def initialize(ratio:, **attributes)
      @ratio = ratio
      super(**attributes)
    end

    def default_attributes
      { style: { "padding-bottom": "#{100 / @ratio}%" } }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
