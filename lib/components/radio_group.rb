# frozen_string_literal: true

module ShadcnPhlexcomponents
  class RadioGroup < Base
    STYLES = "grid gap-2 outline-none"

    def initialize(name: nil, value: nil, dir: "ltr", include_hidden: true, **attributes)
      @name = name
      @value = value
      @dir = dir
      @include_hidden = include_hidden
      super(**attributes)
    end

    def item(name: nil, value: nil, **attributes)
      RadioGroupItem(name: name || @name, value: value, checked: @value == value, **attributes)
    end

    def items(collection, value_method:, text_method:, wrapper_class: nil)
      wrapper_class = TAILWIND_MERGER.merge("flex items-center space-x-2 #{wrapper_class}")

      if collection.first && collection.first.is_a?(Hash)
        collection = convert_collection_hash_to_struct(collection, value_method: value_method, text_method: text_method)
      end

      collection.each do |item|
        value = item.public_send(value_method)
        text = item.public_send(text_method)
        id = "#{@name.parameterize.underscore}_#{value}"

        div(class: wrapper_class) do
          RadioGroupItem(name: @name, value: value, checked: @value == value, id: id)
          Label(for: id) { text }
        end
      end
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
          controller: "shadcn-phlexcomponents--radio-group",
          "shadcn-phlexcomponents--radio-group-selected-value": @value,
        }
      }
    end
  end
end