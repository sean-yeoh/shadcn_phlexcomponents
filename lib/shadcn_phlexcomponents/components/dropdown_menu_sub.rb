# frozen_string_literal: true

module ShadcnPhlexcomponents
  class DropdownMenuSub < Base
    def initialize(aria_id: nil, **attributes)
      @aria_id = aria_id
      super(**attributes)
    end

    def trigger(**attributes, &)
      DropdownMenuSubTrigger(aria_id: @aria_id, **attributes, &)
    end

    def content(**attributes, &)
      DropdownMenuSubContent(aria_id: @aria_id, **attributes, &)
    end

    def default_attributes
      {
        data: {
          controller: "dropdown-menu-sub",
          action: "keydown.left->dropdown-menu-sub#closeOnLeftKeydown:prevent",
        },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class DropdownMenuSubTrigger < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.dropdown_menu_sub&.dig(:trigger) ||
        {
          base: <<~HEREDOC,
            focus:bg-accent focus:text-accent-foreground data-[state=open]:bg-accent data-[state=open]:text-accent-foreground
            flex cursor-default items-center rounded-sm px-2 py-1.5 text-sm outline-hidden select-none data-[inset]:pl-8
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
        id: "#{@aria_id}-trigger",
        role: "menuitem",
        aria: {
          haspopup: "menu",
          expanded: false,
          controls: "#{@aria_id}-content",
        },
        tabindex: -1,
        data: {
          state: "closed",
          dropdown_menu_sub_target: "trigger",
          dropdown_menu_target: "item",
          action: <<~HEREDOC,
            focus->dropdown-menu#onItemFocus
            blur->dropdown-menu#onItemBlur
            keydown.up->dropdown-menu#focusItem:prevent
            keydown.down->dropdown-menu#focusItem:prevent
            mouseover->dropdown-menu#focusItem
            mouseover->dropdown-menu-sub#open
            click->dropdown-menu-sub#open
            keydown.right->dropdown-menu-sub#open:prevent
            keydown.space->dropdown-menu-sub#open:prevent
            keydown.enter->dropdown-menu-sub#open:prevent
            keydown.left->dropdown-menu-sub#closeParentSubMenu
          HEREDOC
        },
      }
    end

    def view_template(&)
      div(**@attributes) do
        yield

        icon("chevron-right", class: "ml-auto size-4")
      end
    end
  end

  class DropdownMenuSubContent < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.dropdown_menu_sub&.dig(:content) ||
        {
          base: <<~HEREDOC,
            bg-popover text-popover-foreground data-[state=open]:animate-in data-[state=closed]:animate-out
            data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95
            data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2
            data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 z-50 min-w-[8rem]
            origin-(--radix-popper-transform-origin) overflow-hidden rounded-md border p-1 shadow-lg outline-none
          HEREDOC
        }
      ),
    )

    def initialize(aria_id: nil, side: :right, align: :start, **attributes)
      @side = side
      @align = align
      @aria_id = aria_id
      super(**attributes)
    end

    def default_attributes
      {
        id: "#{@aria_id}-content",
        tabindex: -1,
        role: "menu",
        aria: {
          labelledby: "#{@aria_id}-trigger",
          orientation: "vertical",
        },
        data: {
          state: "closed",
          side: @side,
          align: @align,
          dropdown_menu_sub_target: "content",
          action: <<~HEREDOC,
            mouseover->dropdown-menu-sub#open#{" "}
            keydown.up->dropdown-menu-sub#focusItemByIndex:prevent:self
            keydown.down->dropdown-menu-sub#focusItemByIndex:prevent:self
          HEREDOC
        },
      }
    end

    def view_template(&)
      DropdownMenuSubContentContainer do
        div(**@attributes, &)
      end
    end
  end

  class DropdownMenuSubContentContainer < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.dropdown_menu_sub&.dig(:content_container) ||
        {
          base: "fixed top-0 left-0 w-max z-50",
        }
      ),
    )

    def default_attributes
      {
        style: { display: "none" },
        data: { dropdown_menu_sub_target: "contentContainer" },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
