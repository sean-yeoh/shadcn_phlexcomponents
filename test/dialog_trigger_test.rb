# frozen_string_literal: true

require "test_helper"

class DialogTriggerTest < ComponentTest
  def test_it_should_render_dialog_content
    output = render(DialogTrigger.new(aria_id: "dialog-id") { "Dialog trigger" })
    output = output.split("\n").join(" ")

    assert_match(%r{<div.+</div>}, output)
    assert_match(/role="button"/, output)
    assert_match(/aria-haspopup="dialog"/, output)
    assert_match(/aria-expanded="false"/, output)
    assert_match(/aria-controls="dialog-id-content"/, output)
    assert_match(/data-shadcn-phlexcomponents--dialog-target="trigger"/, output)
    assert_match(/data-action="click->shadcn-phlexcomponents--dialog#toggle"/, output)
  end

  def test_it_should_render_as_child
    trigger = DialogTrigger.new(aria_id: "dialog-id", as_child: true) do
      raw(render(Button.new { "Open" }))
    end

    output = render(trigger)
    assert_match(%r{<button.+</button>}, output)
    refute_match(/role="button"/, output)
    assert_match(/aria-haspopup="dialog"/, output)
    assert_match(/aria-expanded="false"/, output)
    assert_match(/aria-controls="dialog-id-content"/, output)
    assert_match(/data-shadcn-phlexcomponents--dialog-target="trigger"/, output)
    assert_match(/data-action="click->shadcn-phlexcomponents--dialog#toggle"/, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(DialogTrigger.new(
      aria_id: "dialog-id",
      class: "test-class",
      data: { action: "test-action" },
    ) { "Dialog content" })
    assert_match(/test-class/, output)
    assert_match(/data-action="click->shadcn-phlexcomponents--dialog#toggle test-action"/, output)
  end
end
