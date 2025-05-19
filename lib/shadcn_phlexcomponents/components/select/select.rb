# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Select < Base
    STYLES = "w-full"

    NATIVE_STYLES = <<~HEREDOC
      flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-2 pr-8
      text-base shadow-sm transition-colors placeholder:text-muted-foreground
      focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring
      disabled:cursor-not-allowed disabled:opacity-50 md:text-sm appearance-none
      relative
    HEREDOC

    NATIVE_OPTION_STYLES = "bg-popover text-popover-foreground"

    def initialize(id: nil,
      name: nil,
      value: nil,
      placeholder: nil,
      side: :bottom,
      native: false,
      dir: "ltr",
      include_blank: false,
      disabled: false,
      aria_id: "select-#{SecureRandom.hex(5)}",
      **attributes)
      @id = id || name
      @name = name
      @value = value
      @placeholder = placeholder
      @side = side
      @native = native
      @dir = dir
      @include_blank = include_blank
      @disabled = disabled
      @aria_id = aria_id
      super(**attributes)
    end

    def trigger(**attributes)
      SelectTrigger(
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
      SelectContent(
        side: @side, aria_id: @aria_id, dir: @dir, include_blank: @include_blank, native: @native, **attributes, &
      )
    end

    def item(**attributes, &)
      SelectItem(aria_id: @aria_id, **attributes, &)
    end

    def label(**attributes, &)
      SelectLabel(aria_id: @aria_id, **attributes, &)
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
        dir: @dir,
        value: @value,
        placeholder: @placeholder,
        disabled: @disabled,
      )

      SelectContent(aria_id: @aria_id, dir: @dir, include_blank: @include_blank, native: @native) do
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
              "select-target": "select",
            },
          ) do
            option(value: "")
            build_native_options(content_element)
          end
        end
      end
    end

    def default_styles
      if @native
        NATIVE_STYLES
      else
        STYLES
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
            side: @side,
            aria_id: @aria_id,
            controller: "select",
            "select-selected-value": @value,
          },
        }
      end
    end

    def build_native_options(content_element)
      content_element.children.each do |content_child|
        next if content_child.is_a?(Nokogiri::XML::Text) || content_child.is_a?(Nokogiri::XML::Comment)

        if content_child.attributes["data-select-target"]&.value == "group"
          group_label = content_child.at_css('[data-select-target="label"]')&.text

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
end
