# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SelectTrigger < Base
    STYLES = <<~HEREDOC
      flex h-9 items-center justify-between whitespace-nowrap rounded-md border
      border-input bg-transparent px-3 py-2 text-sm shadow-sm ring-offset-background
      data-[placeholder]:data-[has-value=false]:text-muted-foreground focus:outline-none focus:ring-1
      focus:ring-ring disabled:cursor-not-allowed disabled:opacity-50 [&>span]:line-clamp-1
      w-full cursor-pointer
    HEREDOC

    def initialize(id: nil, value: nil, placeholder: nil, dir: "ltr", aria_id: nil, **attributes)
      @id = id
      @value = value
      @placeholder = placeholder
      @dir = dir
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template
      button(**@attributes) do
        span(class: "pointer-events-none", data: { "select-target": "triggerText" }) do
          @value || @placeholder
        end

        icon("chevron-down", class: "size-4 opacity-50 text-foreground")
      end
    end

    def default_attributes
      {
        type: "button",
        id: @id,
        dir: @dir,
        role: "combobox",
        aria: {
          autocomplete: "none",
          expanded: false,
          controls: "#{@aria_id}-content",
        },
        data: {
          placeholder: @placeholder,
          has_value: @value.present?.to_s,
          action: <<~HEREDOC,
            click->select#toggle
            keydown.down->select#toggle:prevent
            keydown.up->select#toggle:prevent
          HEREDOC
          "select-target": "trigger",
        },
      }
    end
  end
end
