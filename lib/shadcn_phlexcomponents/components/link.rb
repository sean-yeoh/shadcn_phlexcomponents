# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Link < Base
    class_variants(base: "font-medium underline underline-offset-4")

    def initialize(name = nil, options = nil, html_options = nil)
      @name = name
      @options = options
      @html_options = html_options
    end

    def view_template(&)
      if block_given?
        @html_options = @options
        @options = @name
      end

      @html_options ||= {}
      variant = @html_options.delete(:variant)
      size = @html_options.delete(:size) || :default

      @html_options[:class] = if variant
        Button.new.class_variants(variant: variant, size: size, class: @html_options[:class])
      else
        class_variants(class: @html_options[:class])
      end

      if block_given?
        link_to(@options, @html_options, &)
      else
        link_to(@name, @options, @html_options)
      end
    end
  end
end
