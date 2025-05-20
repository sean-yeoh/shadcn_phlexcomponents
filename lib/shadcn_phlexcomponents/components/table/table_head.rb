# frozen_string_literal: true

module ShadcnPhlexcomponents
  class TableHead < Base
    STYLES = <<~HEREDOC
      h-10 px-2 text-left align-middle font-medium text-muted-foreground
      [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]#{"  "}
    HEREDOC

    def view_template(&)
      th(**@attributes, &)
    end
  end
end
