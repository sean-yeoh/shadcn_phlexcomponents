# frozen_string_literal: true

class ThemeSwitcher < BaseComponent
  def view_template
    render(Button.new(variant: :ghost, size: :icon, **@attributes)) do
      lucide_icon("sun", class: "hidden dark:inline")
      lucide_icon("moon", class: "inline dark:hidden")
    end
  end

  def default_attributes
    {
      data: {
        controller: "shadcn-phlexcomponents--theme-switcher",
        action: "shadcn-phlexcomponents--theme-switcher#toggle",
      },
    }
  end
end
