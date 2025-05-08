# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Form < Base
    include Phlex::Rails::Helpers::FormWith

    def initialize(model: false, scope: nil, url: nil, format: nil, **options)
      @model = model
      @scope = scope
      @url = url
      @format = format
      @options = options
      @object_name = model ? model.to_model.model_name.param_key : nil
    end

    def field(method = nil, **attributes, &)
      FormField(method, model: @model, object_name: @object_name, **attributes, &)
    end

    def submit(variant: :primary, **attributes, &) 
      Button(variant: variant, type: :submit, **attributes) do
        if block_given?
          yield
        else
          submit_default_value
        end
      end
    end

    def view_template(&)
      form_with(model: @model, scope: @scope, url: @url, format: @format, **@options) do
        yield
      end
    end

    def submit_default_value
      object = @model ? @model.to_model : nil
      key    = object ? (object.persisted? ? :update : :create) : :submit

      model = if object.respond_to?(:model_name)
        object.model_name.human
      else
        @object_name.to_s.humanize
      end

      defaults = []
      # Object is a model and it is not overwritten by as and scope option.
      if object.respond_to?(:model_name) && @object_name.to_s == model.downcase
        defaults << :"helpers.submit.#{object.model_name.i18n_key}.#{key}"
      else
        defaults << :"helpers.submit.#{@object_name}.#{key}"
      end
      defaults << :"helpers.submit.#{key}"
      defaults << "#{key.to_s.humanize} #{model}"

      I18n.t(defaults.shift, model: model, default: defaults)
    end
  end
end
