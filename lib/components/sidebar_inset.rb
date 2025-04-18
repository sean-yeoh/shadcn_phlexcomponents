# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SidebarInset < Base
    STYLES = <<~HEREDOC
      relative flex min-h-svh flex-1 flex-col bg-background peer-data-[variant=inset]:min-h-[calc(100svh-theme(spacing.4))]
      md:peer-data-[variant=inset]:m-2 md:peer-data-[state=collapsed]:peer-data-[variant=inset]:ml-2
      md:peer-data-[variant=inset]:ml-0 md:peer-data-[variant=inset]:rounded-xl md:peer-data-[variant=inset]:shadow
    HEREDOC

    def view_template(&)
      main(**@attributes, &)
    end
  end
end