# frozen_string_literal: true

require "test_helper"

class AspectRatioTest < ComponentTest
  def test_it_should_render_an_aspect_ratio
    output = render(AspectRatio.new)
    assert_match(%r{<div.+</div>}, output)
    assert_match(/position: relative/, output)
    assert_match(/width: 100%/, output)
    assert_match(/padding-bottom: 100.0%/, output)
  end

  def test_it_should_render_base_styles
    output = render(AspectRatio.new)
    assert_includes(output, AspectRatio::STYLES.split("\n").join(" "))
  end

  def test_it_should_render_different_aspect_ratio
    output_1 = render(AspectRatio.new(aspect_ratio: "16/9"))
    assert_match(/padding-bottom: 56.25%/, output_1)

    output_2 = render(AspectRatio.new(aspect_ratio: "21/9"))
    assert_match(/padding-bottom: 42.857142857142854%/, output_2)
  end

  def test_it_should_accept_custom_attributes
    output = render(AspectRatio.new(class: "test-class", data: { action: "test-action" }))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
