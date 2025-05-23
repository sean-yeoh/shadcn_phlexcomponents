# frozen_string_literal: true

require "test_helper"

class PopoverContentTest < ComponentTest
  def test_it_should_render_popover_content
    output = render(PopoverContent.new(aria_id: "test-popover") { "Popover content" })
    assert_match(%r{<div.+</div>}, output)
    assert_match(/Popover content/, output)
    assert_match(/data-popover-target="content"/, output)
    assert_match(/id="test-popover"/, output)
    assert_match(/hidden/, output)
  end

  def test_it_should_render_popover_content_with_custom_side
    output = render(PopoverContent.new(aria_id: "test-popover", side: :top) { "Popover content" })
    assert_match(/data-side="top"/, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(PopoverContent.new(
      aria_id: "test-popover",
      class: "test-class",
      data: { action: "test-action" },
    ) { "Popover content" })

    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
