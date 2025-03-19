# frozen_string_literal: true

require "test_helper"

class LabelTest < ComponentTest
  def test_it_should_render_Label
    output = render(Label.new(for: "my-input") { "My input" })
    assert_match(%r{label.+</label>}, output)
    assert_match(/for="my-input"/, output)
    assert_match(/My input/, output)
  end

  def test_it_should_render_base_styles
    output = render(Label.new)
    assert_includes(output, Label::STYLES.split("\n").join(" "))
  end

  def test_it_should_accept_custom_attributes
    output = render(Label.new(class: "test-class", data: { action: "test-action" }))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
