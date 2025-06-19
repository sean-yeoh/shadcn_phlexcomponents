# frozen_string_literal: true

module ShadcnPhlexcomponents
  class LoadingButton < Base
    def initialize(variant: :default, size: :default, type: :submit, **attributes)
      @variant = variant
      @size = size
      @type = type
      super(**attributes)
    end

    def default_attributes
      {
        type: @type,
        data: {
          controller: "loading-button",
        },
      }
    end

    def view_template(&)
      Button(variant: @variant, size: @size, **@attributes) do
        icon("loader-circle", class: "animate-spin hidden group-aria-busy:inline")
        yield
      end
    end
  end
end
