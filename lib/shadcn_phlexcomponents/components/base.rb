# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Base < Phlex::HTML
    # Include any helpers you want to be available across all components
    include Phlex::Rails::Helpers::Sanitize
    include Phlex::Rails::Helpers::LinkTo
    include Phlex::Rails::Helpers::ButtonTo

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
      element = fragment.children.find do |child|
        if child.is_a?(Nokogiri::XML::Comment)
          false
        else
          (child.is_a?(Nokogiri::XML::Text) && child.text.strip.present?) || !child.is_a?(Nokogiri::XML::Text)
        end
      end

      element
    end

    # https://github.com/heyvito/lucide-rails/blob/master/lib/lucide-rails/rails_helper.rb
    def icon(named, **options)
      options = options.with_indifferent_access
      size = options.delete(:size)
      options = options.merge(width: size, height: size) if size

      svg(**LucideRails.default_options.merge(**options)) { LucideRails::IconProvider.icon(named).html_safe }
    end

    def convert_collection_hash_to_struct(collection, value_method:, text_method:)
      struct_constructor = Struct.new(value_method, text_method)
      collection.map do |item|
        struct = struct_constructor.new
        struct[value_method] = item[value_method]
        struct[text_method] = item[text_method]
        struct
      end
    end

    def item_disabled?(disabled, value)
      if disabled.is_a?(String)
        value == disabled
      elsif disabled.is_a?(Array)
        disabled.include?(value)
      else
        disabled
      end
    end
  end
end
