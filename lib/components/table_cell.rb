# frozen_string_literal: true

module ShadcnPhlexcomponents
  class TableCell < Base
    STYLES = "p-2 align-middle [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]"

    def view_template(&)
      td(**@attributes, &)
    end
  end
end
