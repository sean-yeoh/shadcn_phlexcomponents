# frozen_string_literal: true

module ShadcnPhlexcomponents
  class FormTextarea < Base
    include FormHelpers

    def initialize(
      method = nil,
      model: false,
      object_name: nil,
      value: nil,
      name: nil,
      id: nil,
      label: nil,
      error: nil,
      hint: nil,
      **attributes
    )
      @method = method
      @model = model
      @object_name = object_name
      @value = default_value(value, method)
      @name = name
      @id = id
      @label = label
      @error = default_error(error, method)
      @hint = hint
      @aria_id = "form-field-#{SecureRandom.hex(5)}"
      super(**attributes)
    end

    def view_template(&)
      vanish(&)

      @id ||= field_id(@object_name, @method)
      @name ||= field_name(@object_name, @method)

      FormField(data: label_and_hint_container_attributes) do
        render_label(&)

        # Wrap textarea in div to ensure spacing is correct as there were instances where certain browser extensions
        # injecting html before/after the textarea causing the spacing to go weird.
        div do
          Textarea(
            type: @type,
            id: @id,
            name: @name,
            value: @value,
            aria: aria_attributes,
            **@attributes,
          )
        end

        render_hint(&)
        render_error
      end
    end
  end
end
