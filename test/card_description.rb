# frozen_string_literal: true

require "test_helper"

class CardDescriptionTest < ComponentTest
  def test_it_should_render_card_description
    output = render(CardDescription.new { "Card description" })
    assert_match(/Card description/, output)
    assert_match(%r{<div.+</div>}, output)
  end

  def test_it_should_render_base_styles
    output = render(CardDescription.new)
    assert_includes(output, CardDescription::STYLES.split("\n").join(" "))
  end

  def test_it_should_accept_custom_attributes
    output = render(CardDescription.new(
      class: "test-class",
      data: { action: "test-action" },
    ))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
