# frozen_string_literal: true

module ShadcnPhlexcomponents
  class RadioGroup < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.radio_group&.dig(:root) ||
        {
          base: "grid gap-3 outline-none",
        }
      ),
    )

    def initialize(name: nil, value: nil, dir: "ltr", include_hidden: true, **attributes)
      @name = name
      @value = value
      @dir = dir
      @include_hidden = include_hidden
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

    def item(name: nil, value: nil, checked: false, **attributes)
      RadioGroupItem(name: name || @name, value: value, checked: checked || @value == value, **attributes)
    end

    def items(collection, value_method:, text_method:, container_class: nil, disabled_items: nil, id_prefix: nil, &)
      vanish(&)

      container_class = TAILWIND_MERGER.merge("flex items-center gap-3 #{container_class}")

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

        div(class: container_class) do
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

    def default_attributes
      {
        role: "radiogroup",
        dir: @dir,
        aria: {
          required: false,
        },
        data: {
          controller: "radio-group",
          radio_group_selected_value: @value,
        },
      }
    end

    def view_template(&)
      div(**@attributes) do
        if @include_hidden
          input(type: "hidden", name: @name, autocomplete: "off")
        end

        yield
      end
    end
  end

  class RadioGroupItem < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.radio_group&.dig(:item) ||
        {
          base: <<~HEREDOC,
            border-input text-primary focus-visible:border-ring focus-visible:ring-ring/50 aria-invalid:ring-destructive/20
            dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive dark:bg-input/30 aspect-square size-4
            shrink-0 rounded-full border shadow-xs transition-[color,box-shadow] outline-none focus-visible:ring-[3px]
            disabled:cursor-not-allowed disabled:opacity-50 relative
          HEREDOC
        }
      ),
    )

    def initialize(name: nil, value: nil, checked: false, **attributes)
      @value = value
      @name = name
      @checked = checked
      super(**attributes)
    end

    def view_template(&)
      button(**@attributes) do
        RadioGroupItemIndicator()

        input(
          type: "radio",
          value: @value,
          class: "-translate-x-full pointer-events-none absolute top-0 left-0 size-4 opacity-0",
          name: @name,
          tabindex: -1,
          checked: @checked,
          aria: { hidden: "true" },
          data: {
            radio_group_target: "input",
          },
        )
      end
    end

    def default_attributes
      {
        type: "button",
        tabindex: -1,
        role: "radio",
        aria: {
          checked: @checked.to_s,
        },
        data: {
          checked: @checked.to_s,
          value: @value,
          radio_group_target: "item",
          action: <<~HEREDOC,
            click->radio-group#select
            keydown.right->radio-group#selectItem:prevent
            keydown.down->radio-group#selectItem:prevent
            keydown.up->radio-group#selectItem:prevent
            keydown.left->radio-group#selectItem:prevent
            keydown.enter->radio-group#preventDefault
          HEREDOC
        },
      }
    end
  end

  class RadioGroupItemIndicator < Base
    class_variants(
      **(
        ShadcnPhlexcomponents.configuration.radio_group&.dig(:item_indicator) ||
        {
          base: "relative flex items-center justify-center",
        }
      ),
    )

    def default_attributes
      { data: { radio_group_target: "indicator" } }
    end

    def view_template(&)
      span(**@attributes) do
        icon("circle", class: "fill-primary absolute top-1/2 left-1/2 size-2 -translate-x-1/2 -translate-y-1/2")
      end
    end
  end
end
