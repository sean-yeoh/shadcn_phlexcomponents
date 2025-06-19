# frozen_string_literal: true

module ShadcnPhlexcomponents
  class FormRadioGroup < Base
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

    def aria_attributes
      attrs = super
      attrs[:labelledby] = "#{@aria_id}-label"
      attrs
    end

    def label_attributes(use_label_styles: false, **attributes)
      attrs = super(use_label_styles: use_label_styles, **attributes)
      attrs[:id] = "#{@aria_id}-label"
      attrs
    end

    def radio(**attributes)
      @radio_attributes = attributes
      nil
    end

    def radio_label(**attributes)
      @radio_label_attributes = attributes
      nil
    end

    def view_template(&)
      vanish(&)

      @id ||= field_id(@object_name, @method)
      @name ||= field_name(@object_name, @method)

      div(class: "space-y-2", data: label_and_hint_container_attributes) do
        render_label(&)

        RadioGroup(
          name: @name,
          id: @id,
          value: @value,
          aria: aria_attributes,
          **@attributes,
        ) do |c|
          c.items(
            @collection,
            value_method: @value_method,
            text_method: @text_method,
            disabled_items: @disabled_items,
            id_prefix: @id,
          ) do
            if @radio_attributes
              c.radio(**@radio_attributes)
            end

            if @radio_label_attributes
              c.label(**@radio_label_attributes)
            end
          end
        end

        render_hint(&)
        render_error
      end
    end
  end
end
