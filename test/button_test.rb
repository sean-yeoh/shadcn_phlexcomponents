# frozen_string_literal: true

require "test_helper"

class ButtonTest < ComponentTest
  def test_it_should_render_a_primary_button
    output = render(Button.new)
    assert_match(%r{<button.+</button>}, output)
    assert_includes(output, Button::VARIANTS[:primary])
    assert_includes(output, Button::SIZES[:default])
    assert_match(/type="button"/, output)
  end

  def test_it_should_render_base_styles
    output = render(Button.new)
    assert_includes(output, Button::STYLES.split("\n").join(" "))
  end

  def test_it_should_render_variants
    Button::VARIANTS.each do |variant, variant_styles|
      output = render(Button.new(variant: variant))
      assert_includes(output, variant_styles)
    end
  end

  def test_it_should_render_sizes
    Button::SIZES.each do |size, size_styles|
      output = render(Button.new(size: size))
      assert_includes(output, size_styles)
    end
  end

  def test_it_should_render_type
    output = render(Button.new(type: :submit))
    assert_match(/type="submit"/, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(Button.new(class: "test-class", data: { action: "test-action" }))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
