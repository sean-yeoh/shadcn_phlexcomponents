# frozen_string_literal: true

class Link < BaseComponent
  STYLES = "font-medium underline underline-offset-4"

  def initialize(name = nil, options = nil, html_options = nil, &block)
    @name = name
    @options = options
    @html_options = html_options

    if block_given?
      super(**options)
      @options = @attributes
    else
      super(**html_options)
      @html_options = @attributes
    end
  end

  def view_template(&block)
    if block_given?
      link_to(@options, @html_options, &block)
    else
      link_to(@name, @options, @html_options)
    end
  end
end
