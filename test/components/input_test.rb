# frozen_string_literal: true

require "test_helper"

class InputTest < ComponentTestCase
  def test_renders_basic_input
    component = ShadcnPhlexcomponents::Input.new
    html = assert_component_renders(component)

    assert_has_tag(html, "input")
    assert_has_attribute(html, "type", "text")
  end

  def test_default_type
    component = ShadcnPhlexcomponents::Input.new
    html = assert_component_renders(component)

    assert_has_attribute(html, "type", "text")
  end

  def test_custom_type
    component = ShadcnPhlexcomponents::Input.new(type: :email)
    html = assert_component_renders(component)

    assert_has_attribute(html, "type", "email")
  end

  def test_password_type
    component = ShadcnPhlexcomponents::Input.new(type: :password)
    html = assert_component_renders(component)

    assert_has_attribute(html, "type", "password")
  end

  def test_custom_attributes
    component = ShadcnPhlexcomponents::Input.new(
      id: "email-input",
      name: "email",
      placeholder: "Enter your email",
      value: "test@example.com",
    )
    html = assert_component_renders(component)

    assert_has_attribute(html, "id", "email-input")
    assert_has_attribute(html, "name", "email")
    assert_has_attribute(html, "placeholder", "Enter your email")
    assert_has_attribute(html, "value", "test@example.com")
  end

  def test_disabled_attribute
    component = ShadcnPhlexcomponents::Input.new(disabled: true)
    html = assert_component_renders(component)

    assert_has_attribute(html, "disabled")
  end

  def test_required_attribute
    component = ShadcnPhlexcomponents::Input.new(required: true)
    html = assert_component_renders(component)

    assert_has_attribute(html, "required")
  end

  def test_data_attribute_added
    component = ShadcnPhlexcomponents::Input.new
    html = assert_component_renders(component)

    assert_has_attribute(html, "data-shadcn-phlexcomponents", "input")
  end

  def test_base_classes_present
    component = ShadcnPhlexcomponents::Input.new
    html = assert_component_renders(component)

    # Check for key base classes
    assert_has_class(html, "flex")
    assert_has_class(html, "h-9")
    assert_has_class(html, "w-full")
    assert_has_class(html, "rounded-md")
    assert_has_class(html, "border")
    assert_has_class(html, "bg-transparent")
    assert_has_class(html, "px-3")
    assert_has_class(html, "py-1")
    assert_has_class(html, "text-base")
    assert_has_class(html, "shadow-xs")
  end

  def test_custom_class_merging
    component = ShadcnPhlexcomponents::Input.new(class: "custom-class")
    html = assert_component_renders(component)

    assert_has_class(html, "custom-class")
    # Should still have base classes
    assert_has_class(html, "flex")
    assert_has_class(html, "h-9")
  end

  def test_aria_attributes
    component = ShadcnPhlexcomponents::Input.new(
      "aria-label" => "Email address",
      "aria-describedby" => "email-help",
    )
    html = assert_component_renders(component)

    assert_has_attribute(html, "aria-label", "Email address")
    assert_has_attribute(html, "aria-describedby", "email-help")
  end
end
