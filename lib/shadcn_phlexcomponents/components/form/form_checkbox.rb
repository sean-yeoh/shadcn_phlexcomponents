# frozen_string_literal: true

module ShadcnPhlexcomponents
  class FormCheckbox < Base
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
        use_label_styles ? Label::STYLES : nil,
        "ml-6",
        attributes[:class],
      ].compact.join(" ")
      attributes[:for] ||= @id
      attributes
    end

    def hint_attributes(**attributes)
      attributes[:class] = [
        "ml-6",
        attributes[:class],
      ].compact.join(" ")
      attributes
    end

    def view_template(&)
      vanish(&)

      @id ||= field_id(@object_name, @method)
      @name ||= field_name(@object_name, @method)

      div(class: "space-y-2") do
        div(class: "flex items-top space-x-2") do
          div(class: "grid gap-1.5 relative", data: label_and_hint_container_attributes) do
            @attributes[:class] = "#{@attributes[:class]} -mt-[1.5px] absolute top-0 left-0"

            Checkbox(
              id: @id,
              name: @name,
              value: @value,
              checked: @checked,
              aria: aria_attributes,
              disabled: @disabled,
              **@attributes,
            )

            render_label(&)
            render_hint(&)
          end
        end

        render_error
      end
    end
  end
end
