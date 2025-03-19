# frozen_string_literal: true

class BaseComponent < Phlex::HTML
  # Include any helpers you want to be available across all components
  include Phlex::Rails::Helpers::Routes
  include PhlexKit
  include LucideRails::RailsHelper
  include Phlex::Rails::Helpers::ContentTag
  include Phlex::Rails::Helpers::Sanitize

  TAILWIND_MERGER = ::TailwindMerge::Merger.new.freeze
  STYLES = ""

  SANITIZER_ALLOWED_TAGS = (Rails::HTML::SafeListSanitizer.allowed_tags.to_a +
    ["svg", "path", "polygon", "polyline", "circle", "ellipse", "rect", "line", "use", "defs", "g"]).freeze

  SANITIZER_ALLOWED_ATTRIBUTES = (Rails::HTML::SafeListSanitizer.allowed_attributes.to_a +
    [
      "viewBox",
      "preserveaspectratio",
      "cx",
      "cy",
      "d",
      "fill",
      "height",
      "points",
      "r",
      "stroke",
      "width",
      "x",
      "y",
      "stroke-linejoin",
      "stroke-width",
      "stroke-linecap",
      "aria-hidden",
      "class",
    ]).freeze

  def initialize(**attributes)
    @attributes = mix(default_attributes, attributes)
    @attributes[:class] = TAILWIND_MERGER.merge("#{default_styles} #{@attributes[:class]}")
  end

  if Rails.env.development?
    def before_template
      comment { "Before #{self.class.name}" }
      super
    end
  end

  def default_attributes
    {}
  end

  def default_styles
    self.class::STYLES
  end

  def nokogiri_attributes_to_hash(element)
    hash = {}

    element.attributes.each do |key, attr|
      hash[key] = attr.value
    end

    hash.transform_keys(&:to_sym)
  end

  def sanitize_as_child(html)
    sanitize(
      html,
      tags: SANITIZER_ALLOWED_TAGS,
      attributes: SANITIZER_ALLOWED_ATTRIBUTES,
    )
  end

  def find_as_child(rendered_element)
    fragment = Nokogiri::HTML.fragment(rendered_element)

    element = fragment.children.find do |c|
      if c.is_a?(Nokogiri::XML::Comment)
        false
      else
        (c.is_a?(Nokogiri::XML::Text) && c.text.strip.present?) || !c.is_a?(Nokogiri::XML::Text)
      end
    end

    element
  end
end
