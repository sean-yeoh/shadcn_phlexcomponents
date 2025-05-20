# frozen_string_literal: true

module ShadcnPhlexcomponents
  class FormDateRangePicker < Base
    include FormHelpers

    def initialize(
      start_date_method,
      end_date_method,
      model: false,
      object_name: nil,
      start_date: nil,
      end_date: nil,
      start_date_name: nil,
      end_date_name: nil,
      id: nil,
      label: nil,
      start_date_error: nil,
      end_date_error: nil,
      hint: nil,
      **attributes
    )
      @start_date_method = start_date_method
      @end_date_method = end_date_method
      @model = model
      @object_name = object_name
      @start_date = start_date
      @end_date = start_date
      @start_date_model_value = model&.public_send(start_date_method)
      @end_date_model_value = model&.public_send(end_date_method)
      @start_date_name = start_date_name
      @end_date_name = end_date_name
      @id = id
      @label = label
      @start_date_error = start_date_error || (model ? model.errors.full_messages_for(start_date_method).first : nil)
      @end_date_error = end_date_error || (model ? model.errors.full_messages_for(end_date_method).first : nil)
      @error = (@start_date_error || @end_date_error).present?
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
        rails_label(@object_name, [@start_date_method, @end_date_method].to_sentence, nil, **attrs)
      end
    end

    def render_error
      if @start_date_error && @end_date_error
        FormError(nil, aria_id: @aria_id) do
          span { @start_date_error }
          br
          span { @end_date_error }
        end
      elsif @start_date_error
        FormError(@start_date_error, aria_id: @aria_id)
      elsif @end_date_error
        FormError(@end_date_error, aria_id: @aria_id)
      end
    end

    def view_template(&)
      vanish(&)

      @id ||= field_id(@object_name, @start_date_method)
      @start_date_name ||= field_name(@object_name, @start_date_method)
      @end_date_name ||= field_name(@object_name, @end_date_method)

      div(class: "space-y-2", data: label_and_hint_container_attributes) do
        render_label(&)
        DateRangePicker(
          id: @id,
          start_date_name: @start_date_name,
          end_date_name: @end_date_name,
          start_date: @start_date || @start_date_model_value,
          end_date: @end_date || @end_date_model_value,
          aria: aria_attributes,
          **@attributes,
        )
        render_hint(&)
        render_error
      end
    end
  end
end
