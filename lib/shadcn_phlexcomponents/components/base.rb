# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Base < Phlex::HTML
    include ClassVariants::Helper
    include Phlex::Rails::Helpers::Sanitize
    include Phlex::Rails::Helpers::LinkTo
    include Phlex::Rails::Helpers::ButtonTo

    TAILWIND_MERGER = ::TailwindMerge::Merger.new.freeze

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
        "x1",
        "x2",
        "y1",
        "y2",
      ]).freeze

    def initialize(**attributes)
      merge_default_attributes(attributes)
    end

    def merge_default_attributes(attributes)
      @attributes = mix(default_attributes, attributes)
      @attributes = mix(@attributes, {
        data: {
          shadcn_phlexcomponents: self.class.name.demodulize.underscore.dasherize,
        },
      })

      @attributes[:class] = class_variants(class: @attributes[:class], **@class_variants&.compact)

      if @attributes[:class].blank?
        @attributes.delete(:class)
      end
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

    def merged_as_child_attributes(element, component_attributes)
      element_attributes = nokogiri_attributes_to_hash(element)
      merged_attributes = mix(component_attributes, element_attributes)
      merged_attributes[:class] = TAILWIND_MERGER.merge("#{component_attributes[:class]} #{element_attributes[:class]}")

      # some components are divs that have role="button",
      # we should remove it if the child element is a button
      if component_attributes[:role].present? && component_attributes[:role].to_sym == :button && element.name == "button"
        merged_attributes.delete(:role)
      end

      merged_attributes
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
