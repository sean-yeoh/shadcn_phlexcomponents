# frozen_string_literal: true

require "test_helper"

class CardFooterTest < ComponentTest
  def test_it_should_render_card_footer
    output = render(CardFooter.new { "Card footer" })
    assert_match(/Card footer/, output)
    assert_match(%r{<div.+</div>}, output)
  end

  def test_it_should_render_base_styles
    output = render(CardFooter.new)
    assert_includes(output, CardFooter::STYLES.split("\n").join(" "))
  end

  def test_it_should_accept_custom_attributes
    output = render(CardFooter.new(
      class: "test-class",
      data: { action: "test-action" },
    ))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
