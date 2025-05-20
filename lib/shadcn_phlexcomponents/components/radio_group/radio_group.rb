# frozen_string_literal: true

module ShadcnPhlexcomponents
  class RadioGroup < Base
    STYLES = "grid gap-2 outline-none"

    def initialize(name: nil, value: nil, dir: "ltr", include_hidden: true, item_id_prefix: nil, **attributes)
      @name = name
      @value = value
      @dir = dir
      @include_hidden = include_hidden
      @item_id_prefix = item_id_prefix
      super(**attributes)
    end

    def label(**attributes)
      @label_attributes = attributes
      nil
    end

    def radio(**attributes)
      @radio_attributes = attributes
      nil
    end

    def item(name: nil, value: nil, **attributes)
      RadioGroupItem(name: name || @name, value: value, checked: @value == value, **attributes)
    end

    def items(collection, value_method:, text_method:, wrapper_class: nil, disabled_items: nil, &)
      vanish(&)

      wrapper_class = TAILWIND_MERGER.merge("flex items-center space-x-2 #{wrapper_class}")

      if collection.first&.is_a?(Hash)
        collection = convert_collection_hash_to_struct(collection, value_method: value_method, text_method: text_method)
      end

      collection.each do |item|
        value = item.public_send(value_method)
        text = item.public_send(text_method)
        id = if @item_id_prefix
          "#{@item_id_prefix.parameterize.underscore}_#{value}"
        else
          "#{@name.parameterize.underscore}_#{value}"
        end

        div(class: wrapper_class) do
          RadioGroupItem(
            name: @name,
            value: value,
            checked: @value == value,
            id: id,
            disabled: item_disabled?(disabled_items, value),
            **@radio_attributes,
          )
          Label(for: id, **@label_attributes) { text }
        end
      end

      nil
    end

    def view_template(&)
      div(**@attributes) do
        if @include_hidden
          input(type: "hidden", name: @name, autocomplete: "off")
        end

        yield
      end
    end

    def default_attributes
      {
        role: "radiogroup",
        dir: @dir,
        aria: {
          required: false,
        },
        data: {
          controller: "radio-group",
          "radio-group-selected-value": @value,
        },
      }
    end
  end
end
