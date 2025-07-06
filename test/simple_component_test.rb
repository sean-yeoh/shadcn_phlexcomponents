# frozen_string_literal: true

require "minitest/autorun"
require "phlex"
require "tailwind_merge"

# Simple mock for testing purposes
module ShadcnPhlexcomponents
  class Base < Phlex::HTML
    TAILWIND_MERGER = ::TailwindMerge::Merger.new.freeze

    def initialize(**attributes)
      @attributes = attributes
      @attributes[:class] = TAILWIND_MERGER.merge(@attributes[:class]) if @attributes[:class]
    end

    def merge_classes(*classes)
      TAILWIND_MERGER.merge(classes.compact.join(" "))
    end
  end

  class Button < Base
    def initialize(variant: :default, size: :default, **attributes)
      @variant = variant
      @size = size

      # Base classes
      base_classes = "inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors"

      # Variant classes
      variant_classes = case variant
      when :default
        "bg-primary text-primary-foreground hover:bg-primary/90"
      when :destructive
        "bg-destructive text-white hover:bg-destructive/90"
      when :outline
        "border border-input bg-background hover:bg-accent hover:text-accent-foreground"
      when :secondary
        "bg-secondary text-secondary-foreground hover:bg-secondary/80"
      when :ghost
        "hover:bg-accent hover:text-accent-foreground"
      when :link
        "text-primary underline-offset-4 hover:underline"
      else
        "bg-primary text-primary-foreground hover:bg-primary/90"
      end

      # Size classes
      size_classes = case size
      when :default
        "h-9 px-4 py-2"
      when :sm
        "h-8 rounded-md px-3"
      when :lg
        "h-10 rounded-md px-6"
      when :icon
        "h-9 w-9"
      else
        "h-9 px-4 py-2"
      end

      combined_classes = merge_classes(base_classes, variant_classes, size_classes, attributes[:class])
      super(**attributes.merge(class: combined_classes))
    end

    def view_template(&block)
      button(**@attributes, &block)
    end
  end
end

class SimpleComponentTest < Minitest::Test
  def test_button_renders
    button = ShadcnPhlexcomponents::Button.new { "Click me" }
    html = button.call

    assert_includes(html, "<button")
    assert_includes(html, "Click me")
    assert_includes(html, "inline-flex")
    assert_includes(html, "items-center")
    assert_includes(html, "bg-primary")
  end

  def test_button_variants
    # Test destructive variant
    button = ShadcnPhlexcomponents::Button.new(variant: :destructive) { "Delete" }
    html = button.call

    assert_includes(html, "bg-destructive")
    assert_includes(html, "text-white")

    # Test outline variant
    button = ShadcnPhlexcomponents::Button.new(variant: :outline) { "Outline" }
    html = button.call

    assert_includes(html, "border")
    assert_includes(html, "bg-background")
  end

  def test_button_sizes
    # Test small size
    button = ShadcnPhlexcomponents::Button.new(size: :sm) { "Small" }
    html = button.call

    assert_includes(html, "h-8")
    assert_includes(html, "px-3")

    # Test large size
    button = ShadcnPhlexcomponents::Button.new(size: :lg) { "Large" }
    html = button.call

    assert_includes(html, "h-10")
    assert_includes(html, "px-6")
  end

  def test_custom_attributes
    button = ShadcnPhlexcomponents::Button.new(id: "my-button", "data-testid" => "test-button") { "Custom" }
    html = button.call

    assert_includes(html, 'id="my-button"')
    assert_includes(html, 'data-testid="test-button"')
  end
end
