# frozen_string_literal: true

require_relative "form/form_helpers"
require_relative "form/form_input"
require_relative "form/form_hint"
require_relative "form/form_error"
require_relative "form/form_textarea"
require_relative "form/form_checkbox"
require_relative "form/form_switch"
require_relative "form/form_checkbox_group"
require_relative "form/form_date_picker"
require_relative "form/form_date_range_picker"
require_relative "form/form_select"
require_relative "form/form_combobox"
require_relative "form/form_radio_group"
require_relative "form/form_slider"

module ShadcnPhlexcomponents
  class Form < Base
    include Phlex::Rails::Helpers::FormWith

    def initialize(model: false, scope: nil, url: nil, format: nil, loading: false, **options)
      @model = model
      @scope = scope
      @url = url
      @format = format
      @options = options
      @loading = loading
      @object_name = model ? model.to_model.model_name.param_key : nil
    end

    def input(method = nil, **attributes, &)
      FormInput(method, model: @model, object_name: @object_name, **attributes, &)
    end

    def textarea(method = nil, **attributes, &)
      FormTextarea(method, model: @model, object_name: @object_name, **attributes, &)
    end

    def checkbox(method = nil, **attributes, &)
      FormCheckbox(method, model: @model, object_name: @object_name, **attributes, &)
    end

    def switch(method = nil, **attributes, &)
      FormSwitch(method, model: @model, object_name: @object_name, **attributes, &)
    end

    def checkbox_group(method = nil, collection = [], value_method:, text_method:, **attributes, &)
      FormCheckboxGroup(
        method,
        model: @model,
        object_name: @object_name,
        collection: collection,
        value_method: value_method,
        text_method: text_method,
        **attributes,
        &
      )
    end

    def radio_group(method = nil, collection = [], value_method:, text_method:, **attributes, &)
      FormRadioGroup(
        method,
        model: @model,
        object_name: @object_name,
        collection: collection,
        value_method: value_method,
        text_method: text_method,
        **attributes,
        &
      )
    end

    def select(method = nil, collection = [], value_method:, text_method:, **attributes, &)
      FormSelect(
        method,
        model: @model,
        object_name: @object_name,
        collection: collection,
        value_method: value_method,
        text_method: text_method,
        **attributes,
        &
      )
    end

    def combobox(method = nil, collection = [], value_method:, text_method:, **attributes, &)
      FormCombobox(
        method,
        model: @model,
        object_name: @object_name,
        collection: collection,
        value_method: value_method,
        text_method: text_method,
        **attributes,
        &
      )
    end

    def date_picker(method = nil, **attributes, &)
      FormDatePicker(method, model: @model, object_name: @object_name, **attributes, &)
    end

    def date_range_picker(method = nil, end_method = nil, **attributes, &)
      FormDateRangePicker(method, end_method, model: @model, object_name: @object_name, **attributes, &)
    end

    def slider(method = nil, end_method = nil, **attributes, &)
      FormSlider(method, end_method, model: @model, object_name: @object_name, **attributes, &)
    end

    def submit(value = nil, variant: :default, **attributes, &)
      if @loading
        LoadingButton(variant: variant, type: :submit, **attributes) do
          if block_given?
            yield
          else
            value || submit_default_value
          end
        end
      else
        Button(variant: variant, type: :submit, **attributes) do
          if block_given?
            yield
          else
            value || submit_default_value
          end
        end
      end
    end

    def view_template(&)
      @form_class = @options[:class]
      @options[:class] = "#{@options[:class]} #{"group" if @loading}"
      # rubocop:disable Style/ExplicitBlockArgument
      form_with(model: @model, scope: @scope, url: @url, format: @format, **@options) do
        yield
      end
      # rubocop:enable Style/ExplicitBlockArgument
    end

    # Follows rails f.submit
    # https://github.com/rails/rails/blob/3235827585d87661942c91bc81f64f56d710f0b2/actionview/lib/action_view/helpers/form_helper.rb#L2681-L2706
    def submit_default_value
      object = @model.respond_to?(:to_model) ? @model.to_model : nil
      key    = if object
        object.persisted? ? :update : :create
      else
        :submit
      end

      model = if object.respond_to?(:model_name)
        object.model_name.human
      else
        @object_name.to_s.humanize
      end

      defaults = []
      # Object is a model and it is not overwritten by as and scope option.
      defaults << if object.respond_to?(:model_name) && @object_name.to_s == model.downcase
        :"helpers.submit.#{object.model_name.i18n_key}.#{key}"
      else
        :"helpers.submit.#{@object_name}.#{key}"
      end
      defaults << :"helpers.submit.#{key}"
      defaults << "#{key.to_s.humanize} #{model}"

      I18n.t(defaults.shift, model: model, default: defaults)
    end
  end
end
