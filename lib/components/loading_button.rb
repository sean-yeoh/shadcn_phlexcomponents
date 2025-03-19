# frozen_string_literal: true

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
      lucide_icon("loader-circle", class: "animate-spin hidden group-aria-busy:inline")
      yield
    end
  end
end
