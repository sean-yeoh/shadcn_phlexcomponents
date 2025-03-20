# frozen_string_literal: true

require "test_helper"

class CardTitleTest < ComponentTest
  def test_it_should_render_card_title
    output = render(CardTitle.new { "Card title" })
    assert_match(/Card title/, output)
    assert_match(%r{<div.+</div>}, output)
  end

  def test_it_should_render_base_styles
    output = render(CardTitle.new)
    assert_includes(output, CardTitle::STYLES.split("\n").join(" "))
  end

  def test_it_should_accept_custom_attributes
    output = render(CardTitle.new(
      class: "test-class",
      data: { action: "test-action" },
    ))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
