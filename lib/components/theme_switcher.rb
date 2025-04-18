# frozen_string_literal: true

module ShadcnPhlexcomponents
  class ThemeSwitcher < Base
    def view_template
      Button(variant: :ghost, size: :icon, **@attributes)do
        icon("sun", class: "hidden dark:inline")
        icon("moon", class: "inline dark:hidden")
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
end