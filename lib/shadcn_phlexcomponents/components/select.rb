# frozen_string_literal: true

module ShadcnPhlexcomponents
  NATIVE_OPTION_STYLES = "bg-popover text-popover-foreground"

  class Select < Base
    def initialize(
      id: nil,
      name: nil,
      value: nil,
      placeholder: nil,
      native: false,
      include_blank: false,
      disabled: false,
      **attributes
    )
      @id = id
      @name = name
      @value = value
      @placeholder = placeholder
      @native = native
      @include_blank = include_blank
      @disabled = disabled
      @aria_id = "select-#{SecureRandom.hex(5)}"
      super(**attributes)
    end

    def class_variants(**args)
      if @native
        Input.new.class_variants(class: "appearance-none #{args[:class]}")
      else
        TAILWIND_MERGER.merge("w-full #{args[:class]}")
      end
    end

    def trigger(**attributes)
      SelectTrigger(
        id: @id,
        aria_id: @aria_id,
        value: @value,
        placeholder: @placeholder,
        disabled: @disabled,
        **attributes,
      )
    end

    def content(**attributes, &)
      SelectContent(
        aria_id: @aria_id, include_blank: @include_blank, native: @native, **attributes, &
      )
    end

    def item(**attributes, &)
      SelectItem(aria_id: @aria_id, **attributes, &)
    end

    def label(**attributes, &)
      SelectLabel(**attributes, &)
    end

    def group(**attributes, &)
      SelectGroup(aria_id: @aria_id, **attributes, &)
    end

    def items(collection, value_method:, text_method:, disabled_items: nil, &)
      vanish(&)

      if collection.first&.is_a?(Hash)
        collection = convert_collection_hash_to_struct(collection, value_method: value_method, text_method: text_method)
      end

      SelectTrigger(
        id: @id,
        aria_id: @aria_id,
        value: @value,
        placeholder: @placeholder,
        disabled: @disabled,
      )

      SelectContent(aria_id: @aria_id, include_blank: @include_blank, native: @native) do
        collection.each do |item|
          value = item.public_send(value_method)
          text = item.public_send(text_method)

          SelectItem(value: value, aria_id: @aria_id, disabled: item_disabled?(disabled_items, value)) { text }
        end
      end
    end

    def view_template(&)
      content = capture(&)
      element = Nokogiri::HTML.fragment(content.to_s)
      content_element = element.css('[data-select-target="content"]')

      if @native
        div(class: "relative") do
          select(**@attributes) do
            if @placeholder || @include_blank
              option(value: "", class: NATIVE_OPTION_STYLES) { @placeholder }
            end

            build_native_options(content_element)
          end

          icon("chevron-down", class: "size-4 absolute opacity-50 top-1/2 -translate-y-1/2 right-3 pointer-events-none")
        end
      else
        div(**@attributes) do
          yield

          select(
            name: @name,
            disabled: @disabled,
            class: "sr-only",
            tabindex: -1,
            data: {
              select_target: "select",
            },
          ) do
            option(value: "")
            build_native_options(content_element)
          end
        end
      end
    end

    def default_attributes
      if @native
        {
          id: @id,
          name: @name,
          disabled: @disabled,
        }
      else
        {
          data: {
            aria_id: @aria_id,
            controller: "select",
            select_selected_value: @value,
          },
        }
      end
    end

    def build_native_options(content_element)
      content_element.children.each do |content_child|
        next if content_child.is_a?(Nokogiri::XML::Text) || content_child.is_a?(Nokogiri::XML::Comment)

        if content_child.attributes["data-select-target"]&.value == "group"
          group_label = content_child.at_css('[data-shadcn-phlexcomponents="select-label"]')&.text

          optgroup(label: group_label, class: NATIVE_OPTION_STYLES) do
            content_child.css('[data-select-target="item"]').each do |i|
              option(
                value: i.attributes["data-value"].value,
                class: NATIVE_OPTION_STYLES,
                selected: i.attributes["data-value"].value == @value,
                disabled: i.attributes["data-disabled"]&.value == "",
              ) do
                i.text
              end
            end
          end
        elsif content_child.attributes["data-select-target"]&.value == "item"

          option(
            value: content_child.attributes["data-value"].value,
            class: NATIVE_OPTION_STYLES,
            selected: content_child.attributes["data-value"].value == @value,
            disabled: content_child.attributes["data-disabled"]&.value == "",
          ) do
            content_child.text
          end
        end
      end
    end
  end

  class SelectTrigger < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.select&.dig(:trigger) ||
        {
          base: <<~HEREDOC,
            border-input [&_svg:not([class*='text-'])]:text-muted-foreground
            focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40
            aria-invalid:border-destructive dark:bg-input/30 dark:hover:bg-input/50 flex items-center
            justify-between gap-2 rounded-md border bg-transparent px-3 py-2 text-sm whitespace-nowrap shadow-xs
            transition-[color,box-shadow] outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50
            data-[size=default]:h-9 data-[size=sm]:h-8 *:data-[select-target=triggerText]:line-clamp-1#{" "}
            *:data-[select-target=triggerText]:flex *:data-[select-target=triggerText]:items-center *:data-[select-target=triggerText]:gap-2
            [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4
            data-[placeholder]:data-[has-value=false]:text-muted-foreground w-full
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
        span(class: "pointer-events-none", data: { select_target: "triggerText" }) do
          @value || @placeholder
        end

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
            click->select#toggle
            keydown.down->select#open:prevent
            keydown.space->select#open:prevent
            keydown.enter->select#open:prevent
          HEREDOC
          select_target: "trigger",
        },
      }
    end
  end

  class SelectContent < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.select&.dig(:content) ||
        {
          base: <<~HEREDOC,
            bg-popover text-popover-foreground data-[state=open]:animate-in data-[state=closed]:animate-out
            data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95
            data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2
            data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 relative z-50
            max-h-(--radix-popper-available-height) min-w-[8rem] origin-(--radix-popper-transform-origin)
            overflow-x-hidden overflow-y-auto rounded-md border shadow-md p-1 pointer-events-auto outline-none
          HEREDOC
        }
      ),
    )

    def initialize(include_blank: false, native: false, side: :bottom, align: :center, aria_id: nil, **attributes)
      @include_blank = include_blank
      @native = native
      @side = side
      @align = align
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      SelectContentContainer do
        div(**@attributes) do
          if @include_blank && !@native
            SelectItem(aria_id: @aria_id, value: "", class: "h-8") do
              @include_blank.is_a?(String) ? @include_blank : ""
            end
          end

          yield
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
          select_target: "content",
          action: <<~HEREDOC,
            select:click:outside->select#clickOutside
            keydown.up->select#focusItemByIndex:prevent:self
            keydown.down->select#focusItemByIndex:prevent:self
          HEREDOC
        },
      }
    end
  end

  class SelectLabel < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.select&.dig(:label) ||
        {
          base: "text-muted-foreground px-2 py-1.5 text-xs",
        }
      ),
    )

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class SelectItem < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.select&.dig(:item) ||
        {
          base: <<~HEREDOC,
            focus:bg-accent focus:text-accent-foreground [&_svg:not([class*='text-'])]:text-muted-foreground
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
      @aria_labelledby = "#{@aria_id}-#{@value.dasherize.parameterize}"
      super(**attributes)
    end

    def view_template(&)
      div(**@attributes) do
        span(id: @aria_labelledby, &)
        SelectItemIndicator()
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
            click->select#select
            mouseover->select#focusItem
            keydown.up->select#focusItem:prevent
            keydown.down->select#focusItem:prevent
            focus->select#onItemFocus
            blur->select#onItemBlur
            keydown.enter->select#select:prevent
            keydown.space->select#select:prevent
            mouseout->select#focusContent
          HEREDOC
          select_target: "item",
        },
      }
    end
  end

  class SelectGroup < Base
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
          select_target: "group",
        },
      }
    end
  end

  class SelectSeparator < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.select&.dig(:separator) ||
        {
          base: "bg-border pointer-events-none -mx-1 my-1 h-px",
        }
      ),
    )

    def view_template(&)
      div(**@attributes, &)
    end

    def default_attributes
      { aria: { hidden: "true" } }
    end
  end

  class SelectContentContainer < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.select&.dig(:content_container) ||
        {
          base: "fixed top-0 left-0 w-max z-50",
        }
      ),
    )

    def default_attributes
      {
        style: { display: "none" },
        data: { select_target: "contentContainer" },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class SelectItemIndicator < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.select&.dig(:item_indicator) ||
        {
          base: <<~HEREDOC,
            absolute right-2 h-3.5 w-3.5 items-center hidden justify-center#{" "}
            group-aria-[selected=true]/item:flex group-data-[value='']/item:hidden#{" "}
          HEREDOC
        }
      ),
    )

    def view_template
      span(**@attributes) do
        icon("check", class: "size-4")
      end
    end
  end
end
