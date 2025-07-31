# frozen_string_literal: true

module ShadcnPhlexcomponents
  class CheckboxGroup < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.checkbox_group&.dig(:root) ||
        {
          base: "space-y-1.5",
        }
      ),
    )

    def initialize(name:, value: [], include_hidden: true, **attributes)
      @name = name
      @value = value
      @include_hidden = include_hidden
      super(**attributes)
    end

    def label(**attributes)
      @label_attributes = attributes
      nil
    end

    def checkbox(**attributes)
      @checkbox_attributes = attributes
      nil
    end

    def items(collection, value_method:, text_method:, container_class: nil, disabled_items: nil, id_prefix: nil, &)
      vanish(&)

      if collection.first&.is_a?(Hash)
        collection = convert_collection_hash_to_struct(collection, value_method: value_method, text_method: text_method)
      end

      collection.each do |item|
        value = item.public_send(value_method)
        text = item.public_send(text_method)

        id = if id_prefix
          "#{id_prefix.parameterize.underscore}_#{value}"
        else
          "#{@name.parameterize.underscore}_#{value}"
        end

        CheckboxGroupItemContainer(class: container_class) do
          Checkbox(
            name: "#{@name}[]",
            id: id,
            value: value,
            checked: @value.include?(value),
            include_hidden: false,
            disabled: item_disabled?(disabled_items, value),
            **@checkbox_attributes,
          )
          Label(for: id, **@label_attributes) { text }
        end
      end

      nil
    end

    def default_attributes
      {
        role: "group",
      }
    end

    def view_template(&)
      div(**@attributes) do
        yield

        if @include_hidden
          input(type: "hidden", name: "#{@name}[]", autocomplete: "off")
        end
      end
    end
  end

  class CheckboxGroupItemContainer < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.checkbox_group&.dig(:item_container) ||
        {
          base: "flex flex-row items-center gap-2",
        }
      ),
    )

    def view_template(&)
      div(**@attributes, &)
    end
  end
end
