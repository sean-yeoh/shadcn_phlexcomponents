# frozen_string_literal: true

require "test_helper"

class DialogContentTest < ComponentTest
  def test_it_should_render_dialog_content
    output = render(DialogContent.new(aria_id: "dialog-id") { "Dialog content" })
    output = output.split("\n").join(" ")

    assert_match(%r{<div.+</div>}, output)
    assert_match(%r{<button.+</button>}, output)
    assert_match(%r{<svg.+</svg>}, output)
    assert_match(/id="dialog-id-content"/, output)
    assert_match(/tabindex="-1"/, output)
    assert_match(/role="dialog"/, output)
    assert_match(/aria-describedby="dialog-id-description"/, output)
    assert_match(/aria-labelledby="dialog-id-title"/, output)
    assert_match(/data-shadcn-phlexcomponents--dialog-target="content"/, output)
    assert_match(%r{<button.+data-action="click->shadcn-phlexcomponents--dialog#close".+</button>}, output)
  end

  def test_it_should_render_base_styles
    output = render(DialogContent.new(aria_id: "dialog-id") { "Dialog content" })
    output = output.split("\n").join(" ")
    assert_includes(output, "#{DialogContent::STYLES.split("\n").join(" ")} hidden")
    assert_includes(output, DialogContent::CLOSE_BUTTON_STYLES.split("\n").join(" "))
  end

  def test_it_should_accept_custom_attributes
    output = render(DialogContent.new(
      aria_id: "dialog-id",
      class: "test-class",
      data: { action: "test-action" },
    ) { "Dialog content" })
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
