# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SidebarMenuItem < Base
    def view_template(&)
      li(**@attributes, &)
    end
  end
end