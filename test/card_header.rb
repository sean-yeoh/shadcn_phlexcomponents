# frozen_string_literal: true

require "test_helper"

class CardHeaderTest < ComponentTest
  def test_it_should_render_card_header
    output = render(CardHeader.new { "Card header" })
    assert_match(/Card header/, output)
    assert_match(%r{<div.+</div>}, output)
  end

  def test_it_should_render_base_styles
    output = render(CardHeader.new)
    assert_includes(output, CardHeader::STYLES.split("\n").join(" "))
  end

  def test_it_should_accept_custom_attributes
    output = render(CardHeader.new(
      class: "test-class",
      data: { action: "test-action" },
    ))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
