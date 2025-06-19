# frozen_string_literal: true

module ShadcnPhlexcomponents
  module FormHelpers
    module AliasedLabel
      include Phlex::Rails::Helpers::Label

      alias_method :rails_label, :label
    end

    include AliasedLabel
    include Phlex::Rails::Helpers::FieldID
    include Phlex::Rails::Helpers::FieldName

    def label(text = nil, **attributes, &)
      @yield_label = true
      attrs = label_attributes(use_label_styles: false, **attributes)

      if text
        Label(**attrs) { text }
      else
        Label(**attrs, &)
      end
    end

    def hint(text = nil, **attributes, &)
      @yield_hint = true
      attrs = hint_attributes(**attributes)

      if text
        FormHint(text, **attrs)
      else
        FormHint(**attrs, &)
      end
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
        rails_label(@object_name, @method, nil, **attrs)
      end
    end

    def render_hint(&)
      # It's currently not possible to separate the content of the yield in Phlex.
      # So we use Javascript to remove the duplicated hint or label.
      if @yield_label && @yield_hint
        div(data: { remove_label: true }, &)
      elsif @yield_hint
        yield
      elsif @hint
        attrs = hint_attributes
        FormHint(@hint, aria_id: @aria_id, **attrs)
      end
    end

    def render_error
      if @error.present?
        if @error.is_a?(Array)
          FormError(nil, aria_id: @aria_id, class: "space-y-0.5") do
            @error.each do |error|
              span(class: "block") { error }
            end
          end
        else
          FormError(@error, aria_id: @aria_id)
        end
      end
    end

    def label_attributes(use_label_styles: false, **attributes)
      attributes[:class] = [
        use_label_styles ? Label.new.class_variants : nil,
        @error.present? ? "text-destructive" : nil,
        attributes[:class],
      ].compact.join(" ")
      attributes[:for] ||= @id
      attributes
    end

    def hint_attributes(**attributes)
      attributes
    end

    def label_and_hint_container_attributes
      {
        controller: @yield_label && @yield_hint ? "form-field" : nil,
      }.compact
    end

    def aria_attributes
      {
        describedby: describedby,
        invalid: @error.present?.to_s,
      }
    end

    def describedby
      return if !@hint && !@error.present?

      [
        @hint ? "#{@aria_id}-description" : nil,
        @error.present? ? "#{@aria_id}-message" : nil,
      ].compact.join(" ")
    end

    def default_value(value, method)
      return value unless value.nil?
      return unless @model

      if @model.respond_to?(method)
        @model.public_send(method)
      end
    end

    def default_checked(checked, method)
      return checked if [true, false].include?(checked)
      return unless @model

      if @model.respond_to?(method)
        !!@model.public_send(method)
      end
    end

    def default_error(error, method)
      return error unless error.nil?
      return unless @model

      if @model.respond_to?(:errors)
        @model.errors.full_messages_for(method).first
      end
    end
  end
end
