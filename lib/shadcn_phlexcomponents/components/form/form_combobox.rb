# frozen_string_literal: true

module ShadcnPhlexcomponents
  class FormCombobox < Base
    include FormHelpers

    def initialize(
      method = nil,
      model: false,
      object_name: nil,
      collection: [],
      value_method: nil,
      text_method: nil,
      value: nil,
      name: nil,
      id: nil,
      label: nil,
      error: nil,
      hint: nil,
      disabled_items: nil,
      **attributes
    )
      @method = method
      @model = model
      @object_name = object_name

      @collection = if collection.first&.is_a?(Hash)
        convert_collection_hash_to_struct(collection, value_method: value_method, text_method: text_method)
      else
        collection
      end

      @value_method = value_method
      @text_method = text_method
      @value = default_value(value, method)
      @name = name
      @id = id
      @label = label
      @error = default_error(error, method)
      @hint = hint
      @disabled_items = disabled_items
      @aria_id = "form-field-#{SecureRandom.hex(5)}"
      super(**attributes)
    end

    def view_template(&)
      vanish(&)

      @id ||= field_id(@object_name, @method)
      @name ||= field_name(@object_name, @method)

      div(class: "space-y-2", data: label_and_hint_container_attributes) do
        render_label(&)

        Combobox(id: @id, name: @name, value: @value, aria: aria_attributes, **@attributes) do |c|
          c.items(@collection, value_method: @value_method, text_method: @text_method, disabled_items: @disabled_items)
        end

        render_hint(&)
        render_error
      end
    end
  end
end
