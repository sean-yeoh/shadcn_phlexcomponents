# frozen_string_literal: true

module ShadcnPhlexcomponents
  class FormDateRangePicker < Base
    include FormHelpers

    def initialize(
      method,
      end_method,
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
      @end_method = end_method
      @model = model
      @object_name = object_name

      @value = [
        default_value(value ? value[0] : nil, method),
        default_value(value ? value[1] : nil, end_method),
      ]
      @error = [
        default_error(error ? error[0] : nil, method),
        default_error(error ? error[1] : nil, end_method),
      ].compact

      @name = name
      @id = id
      @label = label
      @hint = hint
      @aria_id = "form-field-#{SecureRandom.hex(5)}"
      super(**attributes)
    end

    def render_label(&)
      # It's currently not possible to separate the content of the yield in Phlex.
      # So we use Javascript to remove the duplicated hint or label.
      if @yield_label && @yield_hint
        div(data: { remove_hint: true }, &)
      elsif @yield_label
        yield
      elsif @label
        attrs = label_attributes(use_label_styles: false)
        Label(**attrs) { @label }
      elsif @label != false
        attrs = label_attributes(use_label_styles: true)
        rails_label(@object_name, [@method, @end_method].to_sentence, nil, **attrs)
      end
    end

    def view_template(&)
      vanish(&)

      @id ||= field_id(@object_name, @method)
      @name ||=
        [
          field_name(@object_name, @method),
          field_name(@object_name, @end_method),
        ]

      div(class: "space-y-2", data: label_and_hint_container_attributes) do
        render_label(&)
        DateRangePicker(
          id: @id,
          name: @name,
          value: @value,
          aria: aria_attributes,
          **@attributes,
        )
        render_hint(&)
        render_error
      end
    end
  end
end
