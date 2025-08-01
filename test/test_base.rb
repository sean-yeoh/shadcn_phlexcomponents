# frozen_string_literal: true

require "test_helper"

# Create a simple test component that inherits from Base
class TestComponent < ShadcnPhlexcomponents::Base
  class_variants(
    base: "test-base-class",
    variants: {
      variant: {
        primary: "test-primary",
        secondary: "test-secondary",
      },
      size: {
        sm: "test-sm",
        lg: "test-lg",
      },
    },
    defaults: {
      variant: :primary,
      size: :sm,
    },
  )

  def initialize(variant: :primary, size: :sm, **attributes)
    @class_variants = { variant: variant, size: size }
    super(**attributes)
  end

  def view_template(&)
    div(**@attributes, &)
  end
end

class TestBase < ComponentTest
  def test_it_should_add_data_shadcn_phlexcomponents_attribute
    component = TestComponent.new
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="test-component"')
  end

  def test_it_should_apply_base_classes
    component = TestComponent.new
    output = render(component)

    assert_includes(output, "test-base-class")
  end

  def test_it_should_apply_default_variants
    component = TestComponent.new
    output = render(component)

    assert_includes(output, "test-primary")
    assert_includes(output, "test-sm")
  end

  def test_it_should_apply_custom_variants
    component = TestComponent.new(variant: :secondary, size: :lg)
    output = render(component)

    assert_includes(output, "test-secondary")
    assert_includes(output, "test-lg")
  end

  def test_it_should_merge_custom_classes
    component = TestComponent.new(class: "custom-class")
    output = render(component)

    assert_includes(output, "test-base-class")
    assert_includes(output, "test-primary")
    assert_includes(output, "custom-class")
  end

  def test_it_should_handle_custom_attributes
    component = TestComponent.new(id: "test-id", data: { testid: "test" })
    output = render(component)

    assert_includes(output, 'id="test-id"')
    assert_includes(output, 'data-testid="test"')
    assert_includes(output, 'data-shadcn-phlexcomponents="test-component"')
  end

  def test_it_should_remove_empty_class_attribute
    # Create a component with no base classes or variants
    simple_component_class = Class.new(ShadcnPhlexcomponents::Base) do
      class << self
        def name
          "SimpleComponent"
        end
      end

      def view_template(&)
        div(**@attributes, &)
      end
    end

    component = simple_component_class.new
    output = render(component)

    # Should not have an empty class attribute
    refute_includes(output, 'class=""')
    refute_includes(output, 'class=" "')
  end

  def test_it_should_handle_mix_method_for_attributes
    component = TestComponent.new(
      data: { existing: "value" },
      aria: { label: "test" },
    )
    output = render(component)

    assert_includes(output, 'data-existing="value"')
    assert_includes(output, 'data-shadcn-phlexcomponents="test-component"')
    assert_includes(output, 'aria-label="test"')
  end

  def test_icon_method_should_generate_svg
    # Create a component that uses the icon method
    icon_component_class = Class.new(ShadcnPhlexcomponents::Base) do
      class << self
        def name
          "IconComponent"
        end
      end

      def view_template(&)
        div(**@attributes) do
          icon("check", class: "icon-class", size: 24)
        end
      end
    end

    component = icon_component_class.new
    output = render(component)

    assert_match(%r{<svg[^>]*>.*</svg>}m, output)
    assert_includes(output, 'class="icon-class"')
    assert_includes(output, 'width="24"')
    assert_includes(output, 'height="24"')
  end

  def test_overlay_method_should_generate_overlay_div
    # Create a component that uses the overlay method
    overlay_component_class = Class.new(ShadcnPhlexcomponents::Base) do
      class << self
        def name
          "OverlayComponent"
        end
      end

      def view_template(&)
        div(**@attributes) do
          overlay("test-component")
        end
      end
    end

    component = overlay_component_class.new
    output = render(component)

    assert_includes(output, 'style="display: none;"')
    assert_includes(output, "data-[state=open]:animate-in")
    assert_includes(output, "fixed inset-0 z-50 bg-black/50")
    assert_includes(output, 'data-test-component-target="overlay"')
    assert_includes(output, 'data-state="closed"')
    assert_includes(output, "aria-hidden")
  end

  def test_sanitizer_constants_should_be_defined
    assert_includes(ShadcnPhlexcomponents::Base::SANITIZER_ALLOWED_TAGS, "svg")
    assert_includes(ShadcnPhlexcomponents::Base::SANITIZER_ALLOWED_TAGS, "path")
    assert_includes(ShadcnPhlexcomponents::Base::SANITIZER_ALLOWED_ATTRIBUTES, "viewBox")
    assert_includes(ShadcnPhlexcomponents::Base::SANITIZER_ALLOWED_ATTRIBUTES, "d")
    assert_includes(ShadcnPhlexcomponents::Base::SANITIZER_ALLOWED_ATTRIBUTES, "aria-hidden")
  end

  def test_tailwind_merger_should_be_frozen
    assert(ShadcnPhlexcomponents::Base::TAILWIND_MERGER.frozen?)
  end

  def test_convert_collection_hash_to_struct_method
    component = TestComponent.new
    collection = [
      { value: "1", text: "One" },
      { value: "2", text: "Two" },
    ]

    result = component.convert_collection_hash_to_struct(
      collection,
      value_method: :value,
      text_method: :text,
    )

    assert_equal(2, result.length)
    assert_equal("1", result[0].value)
    assert_equal("One", result[0].text)
    assert_equal("2", result[1].value)
    assert_equal("Two", result[1].text)
  end

  def test_item_disabled_method_with_string
    component = TestComponent.new

    assert(component.item_disabled?("disabled_value", "disabled_value"))
    refute(component.item_disabled?("disabled_value", "other_value"))
  end

  def test_item_disabled_method_with_array
    component = TestComponent.new

    assert(component.item_disabled?(["val1", "val2"], "val1"))
    assert(component.item_disabled?(["val1", "val2"], "val2"))
    refute(component.item_disabled?(["val1", "val2"], "val3"))
  end

  def test_item_disabled_method_with_boolean
    component = TestComponent.new

    assert(component.item_disabled?(true, "any_value"))
    refute(component.item_disabled?(false, "any_value"))
  end

  def test_as_child_functionality_with_nokogiri
    # Test the as_child related methods
    component = TestComponent.new

    html_fragment = "<button class='existing-class'>Test Button</button>"
    element = component.find_as_child(html_fragment)

    assert_equal("button", element.name)

    component_attributes = { class: "component-class", data: { action: "test" } }
    merged_attributes = component.merged_as_child_attributes(element, component_attributes)

    assert_includes(merged_attributes[:class], "existing-class")
    assert_includes(merged_attributes[:class], "component-class")
    assert_equal("test", merged_attributes[:data][:action])
  end

  def test_as_child_role_button_removal
    component = TestComponent.new
    html_fragment = "<button>Test Button</button>"
    element = component.find_as_child(html_fragment)

    component_attributes = { role: "button", class: "component-class" }
    merged_attributes = component.merged_as_child_attributes(element, component_attributes)

    # Role should be removed when merging with actual button element
    refute_includes(merged_attributes.keys, :role)
  end

  def test_sanitize_as_child_method
    component = TestComponent.new
    html_with_svg = '<div>Content <svg><path d="M1 1"/></svg></div>'

    sanitized = component.sanitize_as_child(html_with_svg)

    assert_includes(sanitized, "<div>")
    assert_includes(sanitized, "<svg>")
    assert_includes(sanitized, "<path")
    assert_includes(sanitized, 'd="M1 1"')
  end

  def test_default_attributes_method
    component = TestComponent.new

    # Base component should return empty hash by default
    assert_empty(component.send(:default_attributes))
  end

  def test_class_variants_integration
    # Test that class_variants helper is properly integrated
    component = TestComponent.new(variant: :secondary, size: :lg)

    # Should have the variant-specific classes
    assert_includes(component.instance_variable_get(:@attributes)[:class], "test-secondary")
    assert_includes(component.instance_variable_get(:@attributes)[:class], "test-lg")
    assert_includes(component.instance_variable_get(:@attributes)[:class], "test-base-class")
  end

  def test_phlex_rails_helpers_integration
    # Test that Phlex::Rails helpers are included
    component = TestComponent.new

    assert_respond_to(component, :sanitize)
    assert_respond_to(component, :link_to)
    assert_respond_to(component, :button_to)
  end
end

# Test a component with default_attributes override
class TestComponentWithDefaults < ShadcnPhlexcomponents::Base
  def default_attributes
    { role: "test-role", aria: { label: "test-label" } }
  end

  def view_template(&)
    div(**@attributes, &)
  end
end

class TestBaseWithDefaults < ComponentTest
  def test_it_should_merge_default_attributes
    component = TestComponentWithDefaults.new
    output = render(component)

    assert_includes(output, 'role="test-role"')
    assert_includes(output, 'aria-label="test-label"')
    assert_includes(output, 'data-shadcn-phlexcomponents="test-component-with-defaults"')
  end

  def test_it_should_merge_default_attributes_with_custom
    component = TestComponentWithDefaults.new(role: "custom-role")
    output = render(component)

    # The mix method concatenates attributes, so role becomes "test-role custom-role"
    assert_includes(output, 'role="test-role custom-role"')
    assert_includes(output, 'aria-label="test-label"')
  end
end
