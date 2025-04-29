# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Link < Base
    STYLES = "font-medium underline underline-offset-4"

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
      @html_options = mix(default_attributes, @html_options)
      @html_options[:class] = TAILWIND_MERGER.merge("#{default_styles} #{@html_options[:class]}")

      if block_given?
        link_to(@options, @html_options, &)
      else
        link_to(@name, @options, @html_options)
      end
    end
  end
end
