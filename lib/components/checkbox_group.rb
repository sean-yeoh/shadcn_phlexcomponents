# frozen_string_literal: true

module ShadcnPhlexcomponents
  class CheckboxGroup < Base
    STYLES = "space-y-1.5"

    def initialize(name:, value: [], include_hidden: true, **attributes)
      @name = name
      @value = value
      @include_hidden = include_hidden
      super(**attributes)
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
          Checkbox(name: "#{@name}[]", 
                          id: id,
                          value: value,
                          checked: @value.include?(value),
                          include_hidden: false
                        )
          Label(for: id) { text }
        end
      end
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
end