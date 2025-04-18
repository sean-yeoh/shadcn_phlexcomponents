# frozen_string_literal: true

module ShadcnPhlexcomponents
  class AlertDialogActionTo < Base
    def initialize(name = nil, options = nil, html_options = nil)
      @name = name
      @options = options
      @html_options = html_options
    end

    def default_attributes
      {
        data: {
          action: "click->shadcn-phlexcomponents--alert-dialog#close",
        },
      }
    end

    def default_styles
      Button.default_styles(variant: @variant, size: :default)
    end

    def view_template(&)
      @html_options, @options = @options, @name if block_given?
      @html_options ||= {}
      @variant = @html_options.delete(:variant) || :primary
      @html_options = mix(default_attributes, @html_options)
      @html_options[:class] = TAILWIND_MERGER.merge("#{default_styles} #{@html_options[:class]}")

      if block_given?
        button_to(@options, @html_options, &)
      else
        button_to(@name, @options, @html_options)
      end
    end
  end
end