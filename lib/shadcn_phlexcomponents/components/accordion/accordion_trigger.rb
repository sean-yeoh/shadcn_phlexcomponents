# frozen_string_literal: true

module ShadcnPhlexcomponents
  class AccordionTrigger < Base
    STYLES = <<~HEREDOC
      flex flex-1 items-center justify-between py-4 text-sm font-medium cursor-pointer
      transition-all hover:underline text-left [&[data-state=open]>svg]:rotate-180
      disabled:opacity-50 disabled:hover:no-underline
    HEREDOC

    def initialize(aria_id: nil, **attributes)
      @aria_id = aria_id
      super(**attributes)
    end

    def default_attributes
      {
        type: "button",
        id: "#{@aria_id}-trigger",
        aria: {
          controls: "#{@aria_id}-content",
          expanded: "false",
        },
        data: {
          state: "closed",
          "accordion-target": "trigger",
          action: <<~HEREDOC,
            click->accordion#toggleItem
            keydown.up->accordion#focusPrev:prevent
            keydown.down->accordion#focusNext:prevent
          HEREDOC
        },
      }
    end

    def view_template(&)
      h3(class: "flex") do
        button(**@attributes) do
          yield

          icon("chevron-down", class: "size-4 shrink-0 text-muted-foreground transition-transform duration-200")
        end
      end
    end
  end
end
