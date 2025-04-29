# frozen_string_literal: true

module ShadcnPhlexcomponents
  class LoadingButton < Button
    def default_attributes
      {
        type: @type,
        data: {
          controller: "shadcn-phlexcomponents--loading-button",
        },
      }
    end

    def view_template(&)
      button(**@attributes) do
        icon("loader-circle", class: "animate-spin hidden group-aria-busy:inline")
        yield
      end
    end
  end
end
