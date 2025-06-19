# frozen_string_literal: true

module ShadcnPhlexcomponents
  class DropdownMenu < Base
    class_variants(base: "inline-block max-w-fit")

    def initialize(open: false, **attributes)
      @aria_id = "dropdown-menu-#{SecureRandom.hex(5)}"
      @open = open
      super(**attributes)
    end

    def trigger(**attributes, &)
      DropdownMenuTrigger(aria_id: @aria_id, **attributes, &)
    end

    def content(**attributes, &)
      DropdownMenuContent(aria_id: @aria_id, side: @side, **attributes, &)
    end

    def label(**attributes, &)
      DropdownMenuLabel(**attributes, &)
    end

    def item(**attributes, &)
      DropdownMenuItem(**attributes, &)
    end

    def item_to(name = nil, options = nil, html_options = nil, &)
      DropdownMenuItemTo(name, options, html_options, &)
    end

    def separator(**attributes, &)
      DropdownMenuSeparator(**attributes, &)
    end

    def sub(**attributes, &)
      DropdownMenuSub(aria_id: "#{@aria_id}-sub-#{SecureRandom.hex(5)}", **attributes, &)
    end

    def group(**attributes, &)
      DropdownMenuGroup(**attributes, &)
    end

    def default_attributes
      {
        data: {
          controller: "dropdown-menu",
          dropdown_menu_is_open_value: @open.to_s,
        },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class DropdownMenuTrigger < Base
    def initialize(as_child: false, aria_id: nil, **attributes)
      @as_child = as_child
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      if @as_child
        content = capture(&)
        element = find_as_child(content.to_s)
        vanish(&)
        merged_attributes = merged_as_child_attributes(element, @attributes)

        send(element.name, **merged_attributes) do
          sanitize_as_child(element.children.to_s)
        end
      else
        div(**@attributes, &)
      end
    end

    def default_attributes
      {
        id: "#{@aria_id}-trigger",
        role: "button",
        aria: {
          haspopup: "menu",
          expanded: false,
          controls: "#{@aria_id}-content",
        },
        data: {
          state: "closed",
          as_child: @as_child.to_s,
          dropdown_menu_target: "trigger",
          action: <<~HEREDOC,
            click->dropdown-menu#toggle
            keydown.space->dropdown-menu#open
            keydown.enter->dropdown-menu#open
            keydown.down->dropdown-menu#open:prevent
          HEREDOC
        },
      }
    end
  end

  class DropdownMenuContent < Base
    class_variants(
      base: <<~HEREDOC,
        bg-popover text-popover-foreground data-[state=open]:animate-in data-[state=closed]:animate-out
        data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95
        data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2
        data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 z-50
        max-h-(--radix-popper-available-height) min-w-[8rem] origin-(--radix-popper-transform-origin)
        overflow-x-hidden overflow-y-auto rounded-md border p-1 shadow-md pointer-events-auto outline-none
      HEREDOC
    )

    def initialize(side: :bottom, align: :center, aria_id: nil, **attributes)
      @side = side
      @align = align
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      div(
        class: "hidden fixed top-0 left-0 w-max z-50",
        data: { dropdown_menu_target: "contentContainer" },
      ) do
        div(**@attributes, &)
      end
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
          dropdown_menu_target: "content",
          action: <<~HEREDOC,
            dropdown-menu:click:outside->dropdown-menu#clickOutside
            keydown.up->dropdown-menu#focusItemByIndex:prevent:self
            keydown.down->dropdown-menu#focusItemByIndex:prevent:self
          HEREDOC
        },
      }
    end
  end

  class DropdownMenuLabel < Base
    class_variants(base: "px-2 py-1.5 text-sm font-medium data-[inset]:pl-8")

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class DropdownMenuItem < Base
    class_variants(
      base: <<~HEREDOC,
        focus:bg-accent focus:text-accent-foreground data-[variant=destructive]:text-destructive
        data-[variant=destructive]:focus:bg-destructive/10 dark:data-[variant=destructive]:focus:bg-destructive/20
        data-[variant=destructive]:focus:text-destructive data-[variant=destructive]:*:[svg]:!text-destructive
        [&_svg:not([class*='text-'])]:text-muted-foreground relative flex cursor-default items-center gap-2
        rounded-sm px-2 py-1.5 text-sm outline-hidden select-none data-[disabled]:pointer-events-none
        data-[disabled]:opacity-50 data-[inset]:pl-8 [&_svg]:pointer-events-none [&_svg]:shrink-0
        [&_svg:not([class*='size-'])]:size-4
      HEREDOC
    )

    def initialize(as_child: false, variant: :default, disabled: false, **attributes)
      @variant = variant
      @as_child = as_child
      @disabled = disabled
      super(**attributes)
    end

    def view_template(&)
      if @as_child
        content = capture(&)
        element = find_as_child(content.to_s)
        vanish(&)
        merged_attributes = merged_as_child_attributes(element, @attributes)

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
          variant: @variant,
          disabled: @disabled,
          dropdown_menu_target: "item",
          action: <<~HEREDOC,
            click->dropdown-menu#select
            mouseover->dropdown-menu#focusItem
            keydown.up->dropdown-menu#focusItem:prevent
            keydown.down->dropdown-menu#focusItem:prevent
            focus->dropdown-menu#onItemFocus
            blur->dropdown-menu#onItemBlur
            keydown.enter->dropdown-menu#select:prevent
            keydown.space->dropdown-menu#select:prevent
            mouseout->dropdown-menu#focusContent
          HEREDOC

        },
      }
    end
  end

  class DropdownMenuItemTo < DropdownMenuItem
    def initialize(name = nil, options = nil, html_options = nil)
      @name = name
      @options = options
      @html_options = html_options
    end

    def class_variants(**args)
      DropdownMenuItem.new.class_variants(class: "w-full #{args[:class]}")
    end

    def view_template(&)
      if block_given?
        @html_options = @options
        @options = @name
      end

      @html_options ||= {}
      @variant = @html_options.delete(:variant) || :default
      @disabled = @html_options[:disabled]
      merge_default_attributes({})
      @html_options = mix(@attributes, @html_options)

      if block_given?
        button_to(@options, @html_options, &)
      else
        button_to(@name, @options, @html_options)
      end
    end
  end

  class DropdownMenuSeparator < Base
    class_variants(base: "bg-border -mx-1 my-1 h-px")

    def view_template(&)
      div(**@attributes, &)
    end

    def default_attributes
      {
        role: "separator",
        aria: {
          orientation: "horizontal",
        },
      }
    end
  end

  class DropdownMenuGroup < Base
    def default_attributes
      { role: "group" }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
