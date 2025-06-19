# frozen_string_literal: true

module ShadcnPhlexcomponents
  class FormSwitch < Base
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
      checked: nil,
      **attributes
    )
      @method = method
      @model = model
      @object_name = object_name
      @value = value || "1"
      @name = name
      @id = id
      @label = label
      @error = default_error(error, method)
      @hint = hint
      @aria_id = "form-field-#{SecureRandom.hex(5)}"
      @checked = default_checked(checked, method)
      super(**attributes)
    end

    def label_attributes(use_label_styles: false, **attributes)
      attributes[:class] = [
        use_label_styles ? Label.new.class_variants : nil,
        attributes[:class],
      ].compact.join(" ")
      attributes[:for] ||= @id
      attributes
    end

    def view_template(&)
      vanish(&)

      @id ||= field_id(@object_name, @method)
      @name ||= field_name(@object_name, @method)

      div(class: "space-y-2", data: label_and_hint_container_attributes) do
        div(class: "flex items-center gap-2") do
          Switch(
            id: @id,
            name: @name,
            value: @value,
            checked: @checked,
            aria: aria_attributes,
            disabled: @disabled,
            **@attributes,
          )
          render_label(&)
        end
        render_hint(&)
        render_error
      end
    end
  end
end
