# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Combobox < Base
    class_variants(base: "w-full")

    def initialize(
      id: nil,
      name: nil,
      value: nil,
      placeholder: nil,
      dir: "ltr",
      include_blank: false,
      disabled: false,
      **attributes
    )
      @id = id
      @name = name
      @value = value
      @placeholder = placeholder
      @dir = dir
      @include_blank = include_blank
      @disabled = disabled
      @aria_id = "combobox-#{SecureRandom.hex(5)}"
      super(**attributes)
    end

    def trigger(**attributes)
      ComboboxTrigger(
        id: @id,
        aria_id: @aria_id,
        dir: @dir,
        value: @value,
        placeholder: @placeholder,
        disabled: @disabled,
        **attributes,
      )
    end

    def content(**attributes, &)
      ComboboxContent(
        aria_id: @aria_id, dir: @dir, include_blank: @include_blank, **attributes, &
      )
    end

    def item(**attributes, &)
      ComboboxItem(aria_id: @aria_id, **attributes, &)
    end

    def label(**attributes, &)
      ComboboxLabel(**attributes, &)
    end

    def group(**attributes, &)
      ComboboxGroup(aria_id: @aria_id, **attributes, &)
    end

    def empty(**attributes, &)
      ComboboxEmpty(**attributes, &)
    end

    def items(collection, value_method:, text_method:, disabled_items: nil, &)
      vanish(&)

      if collection.first&.is_a?(Hash)
        collection = convert_collection_hash_to_struct(collection, value_method: value_method, text_method: text_method)
      end

      ComboboxTrigger(
        id: @id,
        aria_id: @aria_id,
        dir: @dir,
        value: @value,
        placeholder: @placeholder,
        disabled: @disabled,
      )

      ComboboxContent(aria_id: @aria_id, dir: @dir, include_blank: @include_blank) do
        collection.each do |item|
          value = item.public_send(value_method)
          text = item.public_send(text_method)

          ComboboxItem(value: value, aria_id: @aria_id, disabled: item_disabled?(disabled_items, value)) { text }
        end
      end
    end

    def view_template(&)
      div(**@attributes) do
        input(
          type: :hidden,
          name: @name,
          value: @value,
          data: { combobox_target: "hiddenInput" },
        )

        yield
      end
    end

    def default_attributes
      {
        data: {
          aria_id: @aria_id,
          controller: "combobox",
          combobox_selected_value: @value,
        },
      }
    end
  end

  class ComboboxTrigger < Base
    class_variants(
      base: <<~HEREDOC,
        border-input [&_svg:not([class*='text-'])]:text-muted-foreground
        focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40
        aria-invalid:border-destructive dark:bg-input/30 dark:hover:bg-input/50 flex items-center
        justify-between gap-2 rounded-md border bg-transparent px-3 py-2 text-sm whitespace-nowrap shadow-xs
        transition-[color,box-shadow] outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50
        data-[size=default]:h-9 data-[size=sm]:h-8 *:data-[combobox-target=triggerText]:line-clamp-1#{" "}
        *:data-[combobox-target=triggerText]:flex *:data-[combobox-target=triggerText]:items-center *:data-[combobox-target=triggerText]:gap-2
        [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4
        data-[placeholder]:data-[has-value=false]:text-muted-foreground w-full
      HEREDOC
    )

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
        span(class: "pointer-events-none", data: { combobox_target: "triggerText" }) do
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
            click->combobox#toggle
            keydown.space->combobox#open
            keydown.enter->combobox#open
            keydown.down->combobox#open:prevent
          HEREDOC
          combobox_target: "trigger",
        },
      }
    end
  end

  class ComboboxContent < Base
    class_variants(
      base: <<~HEREDOC,
        bg-popover text-popover-foreground data-[state=open]:animate-in data-[state=closed]:animate-out
        data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95
        data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2
        data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 relative z-50
        max-h-(--radix-popper-available-height) min-w-[8rem] origin-(--radix-popper-transform-origin)
        overflow-x-hidden overflow-y-auto rounded-md border shadow-md pointer-events-auto outline-none
      HEREDOC
    )

    def initialize(include_blank: false, dir: "ltr", side: :bottom, align: :center, aria_id: nil, search_placeholder: "Search...", **attributes)
      @include_blank = include_blank
      @dir = dir
      @side = side
      @align = align
      @search_placeholder = search_placeholder
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      div(
        class: "hidden fixed top-0 left-0 w-max z-50",
        data: { combobox_target: "contentContainer" },
      ) do
        div(**@attributes) do
          label(
            class: "sr-only",
            id: "#{@aria_id}-search-label",
            for: "#{@aria_id}-search",
          ) { @search_placeholder }

          div(class: "flex h-9 items-center gap-2 border-b px-3") do
            icon("search", class: "size-4 shrink-0 opacity-50")

            input(
              class: "placeholder:text-muted-foreground flex w-full rounded-md bg-transparent py-3 text-sm
              outline-hidden disabled:cursor-not-allowed disabled:opacity-50 h-9",
              id: "#{@aria_id}-search",
              placeholder: @search_placeholder,
              type: :text,
              autocomplete: "off",
              autocorrect: "off",
              role: "combobox",
              spellcheck: "false",
              aria: {
                autocomplete: "list",
                expanded: "false",
                controls: "#{@aria_id}-list",
                labelledby: "#{@aria_id}-search-label",
              },
              data: {
                combobox_target: "searchInput",
                action: "input->combobox#search",
              },
            )
          end

          div(class: "p-1 max-h-80 overflow-y-auto", id: "#{@aria_id}-list", data: { combobox_target: "list" }) do
            if @include_blank
              ComboboxItem(aria_id: @aria_id, value: "", class: "h-8", hide_icon: true) do
                @include_blank.is_a?(String) ? @include_blank : ""
              end
            end

            div(data: { combobox_target: "results" }, &)
          end
        end
      end
    end

    def default_attributes
      {
        id: "#{@aria_id}-content",
        dir: @dir,
        tabindex: -1,
        role: "listbox",
        aria: {
          labelledby: "#{@aria_id}-trigger",
          orientation: "vertical",
        },
        data: {
          side: @side,
          align: @align,
          state: "closed",
          combobox_target: "content",
          action: <<~HEREDOC,
            combobox:click:outside->combobox#clickOutside
            keydown.up->combobox#highlightItem:prevent
            keydown.down->combobox#highlightItem:prevent
            keydown.enter->combobox#select
          HEREDOC
        },
      }
    end
  end

  class ComboboxLabel < Base
    class_variants(
      base: "text-muted-foreground px-2 py-1.5 text-xs",
    )

    def initialize(**attributes)
      super(**attributes)
    end

    def view_template(&)
      div(**@attributes, &)
    end

    def default_attributes
      {
        data: {
          combobox_target: "label",
        },
      }
    end
  end

  class ComboboxItem < Base
    class_variants(
      base: <<~HEREDOC,
        data-[highlighted=true]:bg-accent data-[highlighted=true]:text-accent-foreground [&_svg:not([class*='text-'])]:text-muted-foreground
        relative flex w-full cursor-default items-center gap-2 rounded-sm py-1.5 pr-8 pl-2 text-sm
        outline-hidden select-none data-[disabled]:pointer-events-none data-[disabled]:opacity-50
        [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4
        *:[span]:last:items-center *:[span]:last:gap-2 group/item
      HEREDOC
    )

    def initialize(value: nil, disabled: false, aria_id: nil, **attributes)
      @value = value
      @disabled = disabled
      @aria_id = aria_id
      @aria_labelledby = "#{@aria_id}-item-#{SecureRandom.hex(5)}"
      super(**attributes)
    end

    def view_template(&)
      div(**@attributes) do
        span(id: @aria_labelledby, &)

        span(class: "absolute right-2 h-3.5 w-3.5 items-center hidden justify-center
                    group-aria-[selected=true]/item:flex group-data-[value='']/item:hidden") do
          icon("check", class: "size-4")
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
          highlighted: "false",
          disabled: @disabled,
          value: @value,
          action: <<~HEREDOC,
            click->combobox#select
            mouseover->combobox#highlightItem
          HEREDOC
          combobox_target: "item",
        },
      }
    end
  end

  class ComboboxGroup < Base
    def initialize(aria_id: nil, **attributes)
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      div(**@attributes, &)
    end

    def default_attributes
      {
        role: "group",
        aria: {
          labelledby: "#{@aria_id}-group-#{SecureRandom.hex(5)}",
        },
        data: {
          combobox_target: "group",
        },
      }
    end
  end

  class ComboboxSeparator < Base
    class_variants(base: "bg-border pointer-events-none -mx-1 my-1 h-px")

    def view_template(&)
      div(**@attributes, &)
    end

    def default_attributes
      { aria: { hidden: "true" } }
    end
  end

  class ComboboxEmpty < Base
    class_variants(base: "py-6 text-center text-sm hidden")

    def default_attributes
      {
        role: "presentation",
        data: { combobox_target: "empty" },
      }
    end

    def view_template(&)
      if block_given?
        div(**@attributes, &)
      else
        div(**@attributes) { "No results found" }
      end
    end
  end
end
