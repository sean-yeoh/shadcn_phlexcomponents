# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Tabs < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.tabs&.dig(:root) ||
        {
          base: "flex flex-col gap-2",
        }
      ),
    )

    def initialize(value: nil, dir: "ltr", **attributes)
      @dir = dir
      @value = value
      @aria_id = "tabs-#{SecureRandom.hex(5)}"
      super(**attributes)
    end

    def list(**attributes, &)
      TabsList(**attributes, &)
    end

    def trigger(**attributes, &)
      TabsTrigger(aria_id: @aria_id, **attributes, &)
    end

    def content(**attributes, &)
      TabsContent(aria_id: @aria_id, **attributes, &)
    end

    def default_attributes
      {
        dir: @dir,
        data: {
          controller: "tabs",
          tabs_active_value: @value,
        },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class TabsList < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.tabs&.dig(:list) ||
        {
          base: "bg-muted text-muted-foreground inline-flex h-9 w-fit items-center justify-center rounded-lg p-[3px]",
        }
      ),
    )

    def view_template(&)
      div(**@attributes, &)
    end

    def default_attributes
      {
        role: "tablist",
        tabindex: "-1",
        aria: {
          orientation: "horizontal",
        },
      }
    end
  end

  class TabsTrigger < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.tabs&.dig(:trigger) ||
        {
          base: <<~HEREDOC,
            data-[state=active]:bg-background dark:data-[state=active]:text-foreground focus-visible:border-ring
            focus-visible:ring-ring/50 focus-visible:outline-ring dark:data-[state=active]:border-input
            dark:data-[state=active]:bg-input/30 text-foreground dark:text-muted-foreground inline-flex h-[calc(100%-1px)]
            flex-1 items-center justify-center gap-1.5 rounded-md border border-transparent px-2 py-1 text-sm
            font-medium whitespace-nowrap transition-[color,box-shadow] focus-visible:ring-[3px] focus-visible:outline-1
            disabled:pointer-events-none disabled:opacity-50 data-[state=active]:shadow-sm [&_svg]:pointer-events-none
            [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4
          HEREDOC
        }
      ),
    )

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
          tabs_target: "trigger",
          value: @value,
          state: "inactive",
          action: <<~HEREDOC,
            click->tabs#setActiveTab
            keydown.left->tabs#setActiveTab:prevent
            keydown.right->tabs#setActiveTab:prevent
          HEREDOC
        },
      }
    end
  end

  class TabsContent < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.tabs&.dig(:content) ||
        {
          base: "flex-1 outline-none",
        }
      ),
    )

    def initialize(value: nil, aria_id: nil, **attributes)
      @value = value
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      div(**@attributes, &)
    end

    def default_attributes
      {
        id: "#{@aria_id}-content-#{@value}",
        role: "tabpanel",
        tabindex: "0",
        aria: {
          labelledby: "#{@aria_id}-trigger-#{@value}",
        },
        data: {
          value: @value,
          tabs_target: "content",
        },
      }
    end
  end
end
