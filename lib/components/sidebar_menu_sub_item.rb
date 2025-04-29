# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SidebarMenuSubItem < Base
    def view_template(&)
      li(**@attributes, &)
    end
  end
end
