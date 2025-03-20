# frozen_string_literal: true

require "test_helper"

class DialogDescriptionTest < ComponentTest
  def test_it_should_render_dialog_description
    output = render(DialogDescription.new(aria_id: "dialog-id"))
    assert_match(%r{<p.+</p>}, output)
    assert_match(/id="dialog-id-description"/, output)
  end

  def test_it_should_render_base_styles
    output = render(DialogDescription.new(aria_id: "dialog-id"))
    assert_includes(output, DialogDescription::STYLES.split("\n").join(" "))
  end

  def test_it_should_accept_custom_attributes
    output = render(DialogDescription.new(
      aria_id: "dialog-id",
      class: "test-class",
      data: { action: "test-action" },
    ))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
