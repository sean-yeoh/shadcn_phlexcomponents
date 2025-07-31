# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Combobox < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.combobox&.dig(:root) ||
        {
          base: "w-full",
        }
      ),
    )

    def initialize(
      id: nil,
      name: nil,
      value: nil,
      placeholder: nil,
      include_blank: false,
      disabled: false,
      search_path: nil,
      search_error_text: "Something went wrong, please try again.",
      search_empty_text: "No results found",
      search_placeholder_text: "Search...",
      **attributes
    )
      @id = id
      @name = name
      @value = value
      @placeholder = placeholder
      @include_blank = include_blank
      @disabled = disabled
      @search_path = search_path
      @search_error_text = search_error_text
      @search_empty_text = search_empty_text
      @search_placeholder_text = search_placeholder_text
      @aria_id = "combobox-#{SecureRandom.hex(5)}"
      super(**attributes)
    end

    def trigger(**attributes)
      ComboboxTrigger(
        id: @id,
        aria_id: @aria_id,
        value: @value,
        placeholder: @placeholder,
        disabled: @disabled,
        **attributes,
      )
    end

    def content(**attributes, &)
      ComboboxContent(
        include_blank: @include_blank,
        search_error_text: @search_error_text,
        search_empty_text: @search_empty_text,
        search_placeholder_text: @search_placeholder_text,
        aria_id: @aria_id,
        **attributes,
        &
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

    def items(collection, value_method:, text_method:, disabled_items: nil, &)
      vanish(&)

      if collection.first&.is_a?(Hash)
        collection = convert_collection_hash_to_struct(collection, value_method: value_method, text_method: text_method)
      end

      ComboboxTrigger(
        id: @id,
        aria_id: @aria_id,
        value: @value,
        placeholder: @placeholder,
        disabled: @disabled,
      )

      ComboboxContent(
        aria_id: @aria_id,
        include_blank: @include_blank,
        search_error_text: @search_error_text,
        search_empty_text: @search_empty_text,
        search_placeholder_text: @search_placeholder_text,
      ) do
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
          search_path: @search_path,
          combobox_selected_value: @value,
        },
      }
    end
  end

  class ComboboxTrigger < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.combobox&.dig(:trigger) ||
        {
          base: <<~HEREDOC,
            border-input [&_svg:not([class*='text-'])]:text-muted-foreground
            focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40
            aria-invalid:border-destructive dark:bg-input/30 dark:hover:bg-input/50 flex items-center
            justify-between gap-2 rounded-md border bg-transparent px-3 py-2 text-sm whitespace-nowrap shadow-xs
            transition-[color,box-shadow] outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50
            h-9 [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4
            data-[placeholder]:data-[has-value=false]:text-muted-foreground w-full disabled:dark:hover:bg-input/30
          HEREDOC
        }
      ),
    )

    def initialize(id: nil, value: nil, placeholder: nil, aria_id: nil, **attributes)
      @id = id
      @value = value
      @placeholder = placeholder
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template
      button(**@attributes) do
        ComboboxTriggerText(value: @value, placeholder: @placeholder)

        icon("chevron-down", class: "size-4 opacity-50 text-foreground")
      end
    end

    def default_attributes
      {
        type: "button",
        id: @id,
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
            keydown.down->combobox#open:prevent
          HEREDOC
          combobox_target: "trigger",
        },
      }
    end
  end

  class ComboboxContent < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.combobox&.dig(:content) ||
        {
          base: <<~HEREDOC,
            bg-popover text-popover-foreground data-[state=open]:animate-in data-[state=closed]:animate-out
            data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95
            data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2
            data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 relative z-50
            min-w-[8rem] origin-(--radix-popper-transform-origin)
            rounded-md border shadow-md pointer-events-auto outline-none
          HEREDOC
        }
      ),
    )

    def initialize(
      include_blank: false,
      side: :bottom,
      align: :center,
      aria_id: nil,
      search_error_text: nil,
      search_empty_text: nil,
      search_placeholder_text: nil,
      **attributes
    )
      @include_blank = include_blank
      @side = side
      @align = align
      @search_error_text = search_error_text
      @search_empty_text = search_empty_text
      @search_placeholder_text = search_placeholder_text
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      ComboboxContentContainer do
        div(**@attributes) do
          template do
            ComboboxGroup do
              ComboboxLabel { "" }
            end
          end

          label(
            class: "sr-only",
            id: "#{@aria_id}-search-label",
            for: "#{@aria_id}-search",
          ) { @search_placeholder_text }

          ComboboxSearchInputContainer do
            icon("search", class: "size-4 shrink-0 opacity-50")
            ComboboxSearchInput(aria_id: @aria_id, search_placeholder_text: @search_placeholder_text)
          end

          ComboboxListContainer do
            ComboboxText(target: "empty") { @search_empty_text }
            ComboboxText(target: "error") { @search_error_text }
            ComboboxText(target: "loading") do
              div(class: "flex justify-center", aria: { label: "Loading" }) do
                icon("loader-circle", class: "animate-spin")
              end
            end

            div(id: "#{@aria_id}-list", data: { combobox_target: "list" }) do
              if @include_blank
                ComboboxItem(aria_id: @aria_id, value: "", class: "h-8") do
                  @include_blank.is_a?(String) ? @include_blank : ""
                end
              end

              yield
            end
          end
        end
      end
    end

    def default_attributes
      {
        id: "#{@aria_id}-content",
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
            keydown.enter->combobox#select:prevent
          HEREDOC
        },
      }
    end
  end

  class ComboboxLabel < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.combobox&.dig(:label) ||
        {
          base: "text-muted-foreground px-2 py-1.5 text-xs",
        }
      ),
    )

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class ComboboxItem < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.combobox&.dig(:item) ||
        {
          base: <<~HEREDOC,
            data-[highlighted=true]:bg-accent data-[highlighted=true]:text-accent-foreground [&_svg:not([class*='text-'])]:text-muted-foreground
            relative flex w-full cursor-default items-center gap-2 rounded-sm py-1.5 pr-8 pl-2 text-sm
            outline-hidden select-none data-[disabled]:pointer-events-none data-[disabled]:opacity-50
            [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4
            *:[span]:last:items-center *:[span]:last:gap-2 group/item
          HEREDOC
        }
      ),
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

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class ComboboxText < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.combobox&.dig(:text) ||
        {
          base: "py-6 text-center text-sm hidden",
        }
      ),
    )

    def initialize(target:, **attributes)
      @target = target
      super(**attributes)
    end

    def default_attributes
      {
        role: "presentation",
        data: { combobox_target: @target },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class ComboboxSeparator < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.combobox&.dig(:separator) ||
        {
          base: "bg-border pointer-events-none -mx-1 my-1 h-px",
        }
      ),
    )

    def default_attributes
      { aria: { hidden: "true" } }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class ComboboxTriggerText < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.combobox&.dig(:trigger_text) ||
        {
          base: "pointer-events-none line-clamp-1 flex items-center gap-2",
        }
      ),
    )

    def initialize(value: nil, placeholder: nil, **attributes)
      @value = value
      @placeholder = placeholder
      super(**attributes)
    end

    def default_attributes
      { data: { combobox_target: "triggerText" } }
    end

    def view_template(&)
      span(**@attributes) do
        @value || @placeholder
      end
    end
  end

  class ComboboxContentContainer < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.combobox&.dig(:content_container) ||
        {
          base: "fixed top-0 left-0 w-max z-50",
        }
      ),
    )

    def default_attributes
      {
        style: { display: "none" },
        data: { combobox_target: "contentContainer" },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class ComboboxSearchInputContainer < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.combobox&.dig(:search_input_container) ||
        {
          base: "flex h-9 items-center gap-2 border-b px-3",
        }
      ),
    )

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class ComboboxSearchInput < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.combobox&.dig(:search_input) ||
        {
          base: "placeholder:text-muted-foreground flex w-full rounded-md bg-transparent py-3 text-sm
              outline-hidden disabled:cursor-not-allowed disabled:opacity-50 h-9",
        }
      ),
    )

    def initialize(aria_id: nil, search_placeholder_text: nil, **attributes)
      @aria_id = aria_id
      @search_placeholder_text = search_placeholder_text
      super(**attributes)
    end

    def default_attributes
      {
        id: "#{@aria_id}-search",
        placeholder: @search_placeholder_text,
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
          action: "keydown->combobox#inputKeydown input->combobox#search",
        },
      }
    end

    def view_template
      input(**@attributes)
    end
  end

  class ComboboxListContainer < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.combobox&.dig(:list_container) ||
        {
          base: "p-1 max-h-80 overflow-y-auto",
        }
      ),
    )

    def initialize(aria_id: nil, search_placeholder_text: nil, **attributes)
      @aria_id = aria_id
      @search_placeholder_text = search_placeholder_text
      super(**attributes)
    end

    def default_attributes
      { data: { combobox_target: "listContainer" } }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
