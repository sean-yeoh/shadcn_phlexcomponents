# frozen_string_literal: true

require "test_helper"

class TextareaTest < ComponentTest
  def test_it_should_render_textarea
    output = render(Textarea.new(name: "content"))
    assert_match(%r{<textarea.+</textarea>}, output)
    assert_match(/name="content"/, output)
    assert_match(/id="content"/, output)
  end

  def test_it_should_render_textarea_with_value
    output = render(Textarea.new(name: "content", value: "Test content"))
    assert_match(%r{<textarea.+>Test content</textarea>}, output)
  end

  def test_it_should_render_textarea_with_custom_id
    output = render(Textarea.new(name: "content", id: "custom-id"))
    assert_match(/id="custom-id"/, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(Textarea.new(
      name: "content",
      class: "test-class",
      data: { action: "test-action" },
      placeholder: "Enter content",
      rows: 10,
    ))

    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
    assert_match(/placeholder="Enter content"/, output)
    assert_match(/rows="10"/, output)
  end
end
