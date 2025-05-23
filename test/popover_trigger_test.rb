# frozen_string_literal: true

require "test_helper"

class PopoverTriggerTest < ComponentTest
  def test_it_should_render_popover_trigger
    output = render(PopoverTrigger.new(aria_id: "test-popover") { "Click me" })
    assert_match(%r{<button.+</button>}, output)
    assert_match(/Click me/, output)
    assert_match(/data-popover-target="trigger"/, output)
    assert_match(/aria-controls="test-popover"/, output)
    assert_match(/aria-expanded="false"/, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(PopoverTrigger.new(
      aria_id: "test-popover",
      class: "test-class",
      data: { action: "test-action" },
    ) { "Click me" })

    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
