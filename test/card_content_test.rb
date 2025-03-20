# frozen_string_literal: true

require "test_helper"

class CardContentTest < ComponentTest
  def test_it_should_render_card_content
    output = render(CardContent.new { "Card content" })
    assert_match(/Card content/, output)
    assert_match(%r{<div.+</div>}, output)
  end

  def test_it_should_render_base_styles
    output = render(CardContent.new)
    assert_includes(output, CardContent::STYLES.split("\n").join(" "))
  end

  def test_it_should_accept_custom_attributes
    output = render(CardContent.new(
      class: "test-class",
      data: { action: "test-action" },
    ))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
