# frozen_string_literal: true

require "test_helper"

class SeparatorTest < ComponentTest
  def test_it_should_render_horizontal_separator
    output = render(Separator.new)
    assert_match(%r{<div.+role="none".+</div>}, output)
    assert_match(/h-\[1px\]/, output)
    assert_match(/w-full/, output)
  end

  def test_it_should_render_vertical_separator
    output = render(Separator.new(orientation: :vertical))
    assert_match(/h-full/, output)
    assert_match(/w-\[1px\]/, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(Separator.new(
      class: "test-class",
      data: { action: "test-action" },
    ))

    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
