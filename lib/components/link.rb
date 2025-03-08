# frozen_string_literal: true

class Link < BaseComponent
  include Phlex::Rails::Helpers::LinkTo

  STYLES = "font-medium underline underline-offset-4"

  def initialize(name = nil, options = nil, html_options = nil, &block)
    if block_given?
      options ||= {}
      # options[:class] = TAILWIND_MERGER.merge("#{STYLES} #{options[:class]}")
    else
      html_options ||= {}
      # html_options[:class] = TAILWIND_MERGER.merge("#{STYLES} #{html_options[:class]}")
    end

    @name = name
    @options = options
    @html_options = html_options
  end

  def view_template(&block)
    if block_given?
      link_to(@options, @html_options, &block)
    else
      link_to(@name, @options, @html_options)
    end
  end
end
