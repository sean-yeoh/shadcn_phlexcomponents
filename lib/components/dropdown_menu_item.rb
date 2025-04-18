# frozen_string_literal: true

module ShadcnPhlexcomponents

  class DropdownMenuItem < Base
    STYLES = <<~HEREDOC.freeze
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
            click->shadcn-phlexcomponents--dropdown-menu#selectItem
            keydown.up->shadcn-phlexcomponents--dropdown-menu#focusPrevItem:stop
            keydown.down->shadcn-phlexcomponents--dropdown-menu#focusNextItem:stop
            keydown.enter->shadcn-phlexcomponents--dropdown-menu#selectItem:prevent
            keydown.space->shadcn-phlexcomponents--dropdown-menu#selectItem:prevent
            mouseover->shadcn-phlexcomponents--dropdown-menu#focusItem
            mouseout->shadcn-phlexcomponents--dropdown-menu#focusContent
          HEREDOC
          "shadcn-phlexcomponents--dropdown-menu-target": "item"
        }
      }
    end
  end
end