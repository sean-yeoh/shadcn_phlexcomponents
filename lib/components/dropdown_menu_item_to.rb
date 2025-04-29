# frozen_string_literal: true

module ShadcnPhlexcomponents
  class DropdownMenuItemTo < DropdownMenuItem
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
      @disabled = @html_options[:disabled]
      @html_options = mix(default_attributes, @html_options)
      @html_options[:class] = TAILWIND_MERGER.merge("w-full #{default_styles} #{@html_options[:class]}")

      if block_given?
        button_to(@options, @html_options, &)
      else
        button_to(@name, @options, @html_options)
      end
    end
  end
end
