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
      if @error
        FormError(@error, aria_id: @aria_id)
      end
    end

    def label_attributes(use_label_styles: false, **attributes)
      attributes[:class] = [
        use_label_styles ? Label::STYLES : nil,
        @error ? "text-destructive" : nil,
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
        invalid: @error.present?,
      }.compact
    end

    def describedby
      return if !@hint && !@error

      [
        @hint ? "#{@aria_id}-description" : nil,
        @error ? "#{@aria_id}-message" : nil,
      ].compact.join(" ")
    end
  end
end
