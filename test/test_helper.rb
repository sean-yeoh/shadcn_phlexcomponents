# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

# Load dependencies
require "bundler/setup"
require "minitest/autorun"
require "phlex"

# Mock Rails modules for testing
module Rails
  module HTML
    class SafeListSanitizer
      def self.allowed_tags
        ["div", "span", "p", "a", "button", "input"]
      end

      def self.allowed_attributes
        ["class", "id", "data-*", "aria-*"]
      end
    end
  end

  def self.env
    OpenStruct.new(development?: false, test?: true)
  end
end

# Mock ActiveSupport for Rails helper methods
module ActiveSupport
  module Inflector
    def underscore(camel_cased_word)
      camel_cased_word.to_s.gsub("::", "/")
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr("-", "_")
        .downcase
    end

    def dasherize(underscored_word)
      underscored_word.tr("_", "-")
    end

    def demodulize(path)
      path = path.to_s
      if i = path.rindex("::")
        path[(i + 2)..-1]
      else
        path
      end
    end
  end
end

String.include(ActiveSupport::Inflector)

# Mock ClassVariants for testing
module ClassVariants
  module Helper
    def class_variants(css_class: nil, **variants)
      merged_classes = [css_class].compact.join(" ")
      variants.each do |key, value|
        merged_classes += if value.is_a?(Hash)
          " #{value.values.join(" ")}"
        else
          " #{value}"
        end
      end
      merged_classes
    end
  end
end

# Mock Phlex::Rails modules
module Phlex
  module Rails
    module Helpers
      module Sanitize
        def sanitize(html, **options)
          html # Simple mock - just return the html
        end
      end

      module LinkTo
        def link_to(*args, **options)
          # Simple mock
        end
      end

      module ButtonTo
        def button_to(*args, **options)
          # Simple mock
        end
      end
    end
  end
end

# Load our components
require "shadcn_phlexcomponents"

# Simple Base class mock for testing
module ShadcnPhlexcomponents
  class Base < Phlex::HTML
    include ClassVariants::Helper
    include ActiveSupport::Inflector

    def initialize(**attributes)
      @attributes = attributes
      @attributes[:class] = self.class.class_variants(css_class: @attributes[:class], **@class_variants&.compact) if defined?(@class_variants)
      @attributes.delete(:class) if @attributes[:class].blank?

      # Add data attribute
      @attributes[:data] ||= {}
      @attributes[:data]["shadcn-phlexcomponents"] = self.class.name.demodulize.underscore.dasherize
    end

    def self.class_variants(variants)
      @class_variants = variants
    end

    def self.get_class_variants
      @class_variants
    end

    def default_attributes
      {}
    end

    private

    def mix(hash1, hash2)
      hash1.merge(hash2)
    end
  end
end

# Helper class for testing Phlex components
class ComponentTestCase < Minitest::Test
  def render_component(component)
    component.call
  end

  def assert_component_renders(component, expected_html = nil)
    output = render_component(component)
    assert(output.present?, "Component should render output")

    if expected_html
      assert_equal(expected_html.strip, output.strip)
    end

    output
  end

  def assert_has_class(html, class_name)
    assert_includes(html, class_name, "Expected HTML to contain class '#{class_name}'")
  end

  def assert_has_attribute(html, attribute, value = nil)
    if value
      assert_includes(html, "#{attribute}=\"#{value}\"", "Expected HTML to contain #{attribute}=\"#{value}\"")
    else
      assert_includes(html, attribute, "Expected HTML to contain attribute '#{attribute}'")
    end
  end

  def assert_has_tag(html, tag_name)
    assert_includes(html, "<#{tag_name}", "Expected HTML to contain <#{tag_name}> tag")
  end

  def assert_has_content(html, content)
    assert_includes(html, content, "Expected HTML to contain content '#{content}'")
  end
end
