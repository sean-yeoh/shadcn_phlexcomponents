# frozen_string_literal: true

module ShadcnPhlexcomponents
  class TabsTrigger < Base
    STYLES = <<~HEREDOC.freeze
      inline-flex items-center justify-center whitespace-nowrap rounded-md px-3 py-1 text-sm
      font-medium ring-offset-background transition-all focus-visible:outline-none focus-visible:ring-2
      focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50
      data-[state=active]:bg-background data-[state=active]:text-foreground data-[state=active]:shadow
      cursor-pointer
    HEREDOC

    def initialize(value: nil, aria_id: nil, **attributes)
      @value = value
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      button(**@attributes, &)
    end

    def default_attributes
      {
        id: "#{@aria_id}-trigger-#{@value}",
        role: "tab",
        tabindex: "-1",
        aria: {
          controls: "#{@aria_id}-content-#{@value}",
          selected: false,
        },
        data: {
          "shadcn-phlexcomponents--tabs-target": "trigger",
          value: @value,
          state: "inactive",
          action: <<~HEREDOC,
            click->shadcn-phlexcomponents--tabs#setActiveTab
            keydown.left->shadcn-phlexcomponents--tabs#setActiveToPrev:prevent
            keydown.right->shadcn-phlexcomponents--tabs#setActiveToNext:prevent
          HEREDOC
        }
      }
    end
  end
end