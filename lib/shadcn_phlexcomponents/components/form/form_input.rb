# frozen_string_literal: true

module ShadcnPhlexcomponents
  class FormInput < Base
    include FormHelpers

    def initialize(
      method = nil,
      model: false,
      object_name: nil,
      type: :text,
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
      @type = type.to_sym
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

      div(class: "space-y-2", data: label_and_hint_container_attributes) do
        render_label(&)
        Input(type: @type, id: @id, name: @name, value: @value, aria: aria_attributes, **@attributes)
        render_hint(&)
        render_error
      end
    end
  end
end
