# frozen_string_literal: true

require "test_helper"

class DialogTitleTest < ComponentTest
  def test_it_should_render_dialog_title
    output = render(DialogTitle.new(aria_id: "dialog-id"))
    assert_match(%r{<h2.+</h2>}, output)
    assert_match(/id="dialog-id-title"/, output)
  end

  def test_it_should_render_base_styles
    output = render(DialogTitle.new(aria_id: "dialog-id"))
    assert_includes(output, DialogTitle::STYLES.split("\n").join(" "))
  end

  def test_it_should_accept_custom_attributes
    output = render(DialogTitle.new(
      aria_id: "dialog-id",
      class: "test-class",
      data: { action: "test-action" },
    ))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
