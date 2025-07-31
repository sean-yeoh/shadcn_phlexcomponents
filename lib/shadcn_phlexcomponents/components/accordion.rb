# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Accordion < Base
    def initialize(value: nil, multiple: false, **attributes)
      @multiple = multiple
      @value = value.is_a?(Array) ? value : [value]
      @aria_id = "accordion-#{SecureRandom.hex(5)}"
      super(**attributes)
    end

    def item(**attributes, &)
      AccordionItem(**attributes, &)
    end

    def trigger(**attributes, &)
      AccordionTrigger(aria_id: @aria_id, **attributes, &)
    end

    def content(**attributes, &)
      AccordionContent(aria_id: @aria_id, **attributes, &)
    end

    def default_attributes
      {
        data: {
          multiple: @multiple.to_s,
          controller: "accordion",
          accordion_open_items_value: @value.compact.to_json,
        },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class AccordionItem < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.accordion&.dig(:item) ||
        {
          base: "border-b last:border-b-0",
        }
      ),
    )

    def initialize(value:, **attributes)
      @value = value
      super(**attributes)
    end

    def default_attributes
      {
        data: {
          value: @value,
          accordion_target: "item",
        },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class AccordionTrigger < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.accordion&.dig(:trigger) ||
        {
          base: <<~HEREDOC,
            focus-visible:border-ring focus-visible:ring-ring/50 flex flex-1 items-start justify-between
            gap-4 rounded-md py-4 text-left text-sm font-medium transition-all outline-none hover:underline
            focus-visible:ring-[3px] disabled:pointer-events-none disabled:opacity-50 [&[data-state=open]>svg]:rotate-180
          HEREDOC
        }
      ),
    )

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
          accordion_target: "trigger",
          action: <<~HEREDOC,
            click->accordion#toggle
            keydown.up->accordion#focusTrigger:prevent
            keydown.down->accordion#focusTrigger:prevent
          HEREDOC
        },
      }
    end

    def view_template(&)
      h3(class: "flex") do
        button(**@attributes) do
          yield

          icon("chevron-down", class: "text-muted-foreground pointer-events-none size-4 shrink-0 translate-y-0.5 transition-transform duration-200")
        end
      end
    end
  end

  class AccordionContent < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.accordion&.dig(:content) ||
        {
          base: "pt-0 pb-4",
        }
      ),
    )

    def initialize(aria_id: :nil, **attributes)
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      AccordionContentContainer(aria_id: @aria_id) do
        div(**@attributes, &)
      end
    end
  end

  class AccordionContentContainer < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.accordion&.dig(:content_container) ||
        {
          base: "data-[state=closed]:animate-accordion-up data-[state=open]:animate-accordion-down overflow-hidden text-sm",
        }
      ),
    )

    def initialize(aria_id: :nil, **attributes)
      @aria_id = aria_id
      super(**attributes)
    end

    def default_attributes
      {
        id: "#{@aria_id}-content",
        role: "region",
        aria: {
          labelledby: "#{@aria_id}-trigger",
        },
        data: {
          state: "closed",
          accordion_target: "content",
        },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
