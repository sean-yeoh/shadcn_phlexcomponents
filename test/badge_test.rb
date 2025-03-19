# frozen_string_literal: true

require "test_helper"

class BadgeTest < ComponentTest
  def test_it_should_render_badge
    output = render(Badge.new { "Primary badge" })
    assert_match(%r{<div.+</div>}, output)
    assert_includes(output, Badge::VARIANTS[:primary])
    assert_match(/Primary badge/, output)
  end

  def test_it_should_render_base_styles
    output = render(Badge.new)
    assert_includes(output, Badge::STYLES.split("\n").join(" "))
  end

  def test_it_should_render_variants
    Badge::VARIANTS.each do |variant, variant_styles|
      output = render(Badge.new(variant: variant))
      assert_includes(output, variant_styles)
    end
  end

  def test_it_should_accept_custom_attributes
    output = render(Badge.new(class: "test-class", data: { action: "test-action" }))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
