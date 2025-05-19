# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SelectItem < Base
    STYLES = <<~HEREDOC
      group/item relative flex w-full cursor-default select-none items-center
      rounded-sm py-1.5 pl-2 pr-8 text-sm outline-none focus:bg-accent
      focus:text-accent-foreground data-[disabled]:pointer-events-none#{" "}
      data-[disabled]:opacity-50
    HEREDOC

    def initialize(value: nil, disabled: false, hide_icon: false, aria_id: nil, **attributes)
      @value = value
      @disabled = disabled
      @aria_id = aria_id
      @hide_icon = hide_icon
      @aria_labelledby = "#{@aria_id}-#{@value.dasherize.parameterize}"
      super(**attributes)
    end

    def view_template(&)
      div(**@attributes) do
        span(id: @aria_labelledby, &)

        unless @hide_icon
          span(class: "absolute right-2 h-3.5 w-3.5 items-center hidden justify-center
                      group-aria-[selected=true]/item:flex") do
            icon("check", class: "size-4")
          end
        end
      end
    end

    def default_attributes
      {
        role: "option",
        tabindex: -1,
        aria: {
          selected: false,
          labelledby: @aria_labelledby,
        },
        data: {
          disabled: @disabled,
          value: @value,
          action: <<~HEREDOC,
            click->select#selectItem
            keydown.up->select#focusPrevItem:prevent:stop
            keydown.down->select#focusNextItem:prevent:stop
            keydown.enter->select#selectItem:prevent
            keydown.space->select#selectItem:prevent
            mouseover->select#focusItem
            mouseout->select#focusContent
          HEREDOC
          "select-target": "item",
        },
      }
    end
  end
end
