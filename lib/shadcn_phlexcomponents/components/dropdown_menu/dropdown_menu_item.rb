# frozen_string_literal: true

module ShadcnPhlexcomponents
  class DropdownMenuItem < Base
    STYLES = <<~HEREDOC
      relative flex cursor-default select-none items-center gap-2 rounded-sm px-2
      py-1.5 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground
      data-[disabled]:pointer-events-none data-[disabled]:opacity-50 [&>svg]:size-4 [&>svg]:shrink-0
    HEREDOC

    def initialize(as_child: false, disabled: false, **attributes)
      @as_child = as_child
      @disabled = disabled
      super(**attributes)
    end

    def view_template(&)
      if @as_child
        content = capture(&)
        element = find_as_child(content.to_s)

        vanish(&)
        element_attributes = nokogiri_attributes_to_hash(element)
        styles = TAILWIND_MERGER.merge("#{@attributes[:class]} #{element_attributes[:class]}")
        merged_attributes = mix(@attributes, element_attributes)
        merged_attributes[:class] = styles

        send(element.name, **merged_attributes) do
          sanitize_as_child(element.children.to_s)
        end
      else
        div(**@attributes, &)
      end
    end

    def default_attributes
      {
        role: "menuitem",
        tabindex: -1,
        data: {
          disabled: @disabled,
          action: <<~HEREDOC,
            click->dropdown-menu#selectItem
            keydown.up->dropdown-menu#focusPrevItem:stop
            keydown.down->dropdown-menu#focusNextItem:stop
            keydown.enter->dropdown-menu#selectItem:prevent
            keydown.space->dropdown-menu#selectItem:prevent
            mouseover->dropdown-menu#focusItem
            mouseout->dropdown-menu#focusContent
          HEREDOC
          "dropdown-menu-target": "item",
        },
      }
    end
  end
end
