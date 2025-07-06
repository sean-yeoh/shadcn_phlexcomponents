# frozen_string_literal: true

require "test_helper"

class BadgeTest < ComponentTestCase
  def test_renders_basic_badge
    component = ShadcnPhlexcomponents::Badge.new { "New" }
    html = assert_component_renders(component)

    assert_has_tag(html, "span")
    assert_has_content(html, "New")
  end

  def test_default_variant
    component = ShadcnPhlexcomponents::Badge.new { "Default" }
    html = assert_component_renders(component)

    # Should have default variant classes
    assert_has_class(html, "bg-primary")
    assert_has_class(html, "text-primary-foreground")
    assert_has_class(html, "border-transparent")
  end

  def test_variant_secondary
    component = ShadcnPhlexcomponents::Badge.new(variant: :secondary) { "Secondary" }
    html = assert_component_renders(component)

    assert_has_class(html, "bg-secondary")
    assert_has_class(html, "text-secondary-foreground")
  end

  def test_variant_destructive
    component = ShadcnPhlexcomponents::Badge.new(variant: :destructive) { "Error" }
    html = assert_component_renders(component)

    assert_has_class(html, "bg-destructive")
    assert_has_class(html, "text-white")
  end

  def test_variant_outline
    component = ShadcnPhlexcomponents::Badge.new(variant: :outline) { "Outline" }
    html = assert_component_renders(component)

    assert_has_class(html, "text-foreground")
  end

  def test_custom_attributes
    component = ShadcnPhlexcomponents::Badge.new(id: "my-badge", class: "custom-class") { "Custom" }
    html = assert_component_renders(component)

    assert_has_attribute(html, "id", "my-badge")
    assert_has_class(html, "custom-class")
  end

  def test_data_attribute_added
    component = ShadcnPhlexcomponents::Badge.new { "Test" }
    html = assert_component_renders(component)

    assert_has_attribute(html, "data-shadcn-phlexcomponents", "badge")
  end

  def test_base_classes_present
    component = ShadcnPhlexcomponents::Badge.new { "Test" }
    html = assert_component_renders(component)

    # Check for base classes from class_variants
    assert_has_class(html, "inline-flex")
    assert_has_class(html, "items-center")
    assert_has_class(html, "justify-center")
    assert_has_class(html, "rounded-md")
    assert_has_class(html, "border")
    assert_has_class(html, "px-2")
    assert_has_class(html, "py-0.5")
    assert_has_class(html, "text-xs")
    assert_has_class(html, "font-medium")
  end
end
