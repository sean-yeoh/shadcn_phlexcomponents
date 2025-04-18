# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SidebarMenu < Base
    STYLES = "flex w-full min-w-0 flex-col gap-1".freeze

    def view_template(&)
      ul(**@attributes, &)
    end
  end
end