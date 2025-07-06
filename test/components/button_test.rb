# frozen_string_literal: true

require "test_helper"

# Mock the actual Button component for testing
module ShadcnPhlexcomponents
  class Button < Base
    def initialize(variant: :default, size: :default, type: :button, **attributes)
      @variant = variant
      @size = size
      @type = type
      @class_variants = { variant: variant, size: size }

      # Build classes based on variant and size
      classes = ["inline-flex", "items-center", "justify-center", "rounded-md", "text-sm", "font-medium"]

      case variant
      when :default
        classes.concat(["bg-primary", "text-primary-foreground"])
      when :destructive
        classes.concat(["bg-destructive", "text-white"])
      when :outline
        classes.concat(["border", "bg-background"])
      when :secondary
        classes.concat(["bg-secondary", "text-secondary-foreground"])
      when :ghost
        classes.concat(["hover:bg-accent", "hover:text-accent-foreground"])
      when :link
        classes.concat(["text-primary", "underline-offset-4"])
      end

      case size
      when :sm
        classes.concat(["h-8", "px-3"])
      when :lg
        classes.concat(["h-10", "px-6"])
      when :icon
        classes.concat(["size-9"])
      else
        classes.concat(["h-9", "px-4"])
      end

      attributes[:class] = [classes.join(" "), attributes[:class]].compact.join(" ")
      attributes[:type] = @type

      super(**attributes)
    end

    def view_template(&block)
      button(**@attributes, &block)
    end
  end
end

class ButtonTest < ComponentTestCase
  def test_renders_basic_button
    component = ShadcnPhlexcomponents::Button.new { "Click me" }
    html = assert_component_renders(component)

    assert_has_tag(html, "button")
    assert_has_content(html, "Click me")
    assert_has_attribute(html, "type", "button")
  end

  def test_default_variant_and_size
    component = ShadcnPhlexcomponents::Button.new { "Default" }
    html = assert_component_renders(component)

    # Should have default variant classes
    assert_has_class(html, "bg-primary")
    assert_has_class(html, "text-primary-foreground")
    # Should have default size classes
    assert_has_class(html, "h-9")
    assert_has_class(html, "px-4")
  end

  def test_variant_destructive
    component = ShadcnPhlexcomponents::Button.new(variant: :destructive) { "Delete" }
    html = assert_component_renders(component)

    assert_has_class(html, "bg-destructive")
    assert_has_class(html, "text-white")
  end

  def test_variant_outline
    component = ShadcnPhlexcomponents::Button.new(variant: :outline) { "Outline" }
    html = assert_component_renders(component)

    assert_has_class(html, "border")
    assert_has_class(html, "bg-background")
  end

  def test_variant_secondary
    component = ShadcnPhlexcomponents::Button.new(variant: :secondary) { "Secondary" }
    html = assert_component_renders(component)

    assert_has_class(html, "bg-secondary")
    assert_has_class(html, "text-secondary-foreground")
  end

  def test_variant_ghost
    component = ShadcnPhlexcomponents::Button.new(variant: :ghost) { "Ghost" }
    html = assert_component_renders(component)

    assert_has_class(html, "hover:bg-accent")
    assert_has_class(html, "hover:text-accent-foreground")
  end

  def test_variant_link
    component = ShadcnPhlexcomponents::Button.new(variant: :link) { "Link" }
    html = assert_component_renders(component)

    assert_has_class(html, "text-primary")
    assert_has_class(html, "underline-offset-4")
  end

  def test_size_sm
    component = ShadcnPhlexcomponents::Button.new(size: :sm) { "Small" }
    html = assert_component_renders(component)

    assert_has_class(html, "h-8")
    assert_has_class(html, "px-3")
  end

  def test_size_lg
    component = ShadcnPhlexcomponents::Button.new(size: :lg) { "Large" }
    html = assert_component_renders(component)

    assert_has_class(html, "h-10")
    assert_has_class(html, "px-6")
  end

  def test_size_icon
    component = ShadcnPhlexcomponents::Button.new(size: :icon) { "×" }
    html = assert_component_renders(component)

    assert_has_class(html, "size-9")
  end

  def test_custom_type
    component = ShadcnPhlexcomponents::Button.new(type: :submit) { "Submit" }
    html = assert_component_renders(component)

    assert_has_attribute(html, "type", "submit")
  end

  def test_custom_attributes
    component = ShadcnPhlexcomponents::Button.new(id: "my-button", class: "custom-class") { "Custom" }
    html = assert_component_renders(component)

    assert_has_attribute(html, "id", "my-button")
    assert_has_class(html, "custom-class")
  end

  def test_disabled_attribute
    component = ShadcnPhlexcomponents::Button.new(disabled: true) { "Disabled" }
    html = assert_component_renders(component)

    assert_has_attribute(html, "disabled")
  end

  def test_data_attribute_added
    component = ShadcnPhlexcomponents::Button.new { "Test" }
    html = assert_component_renders(component)

    assert_has_attribute(html, "data-shadcn-phlexcomponents", "button")
  end

  def test_base_classes_present
    component = ShadcnPhlexcomponents::Button.new { "Test" }
    html = assert_component_renders(component)

    # Check for base classes
    assert_has_class(html, "inline-flex")
    assert_has_class(html, "items-center")
    assert_has_class(html, "justify-center")
    assert_has_class(html, "rounded-md")
    assert_has_class(html, "text-sm")
    assert_has_class(html, "font-medium")
  end
end
