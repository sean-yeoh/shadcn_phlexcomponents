# frozen_string_literal: true

require "test_helper"

class DialogHeaderTest < ComponentTest
  def test_it_should_render_dialog_header
    output = render(DialogHeader.new)
    assert_match(%r{<div.+</div>}, output)
  end

  def test_it_should_render_base_styles
    output = render(DialogHeader.new)
    assert_includes(output, DialogHeader::STYLES.split("\n").join(" "))
  end

  def test_it_should_accept_custom_attributes
    output = render(DialogHeader.new(
      class: "test-class",
      data: { action: "test-action" },
    ))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
