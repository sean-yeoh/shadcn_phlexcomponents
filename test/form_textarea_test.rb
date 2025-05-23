# frozen_string_literal: true

require "test_helper"

class FormTextareaTest < ComponentTest
  def test_it_should_render_form_textarea
    output = render(FormTextarea.new(:content))
    assert_match(%r{<textarea.+</textarea>}, output)
    assert_match(/name="content"/, output)
    assert_match(/id="content"/, output)
  end

  def test_it_should_render_form_textarea_with_model
    post = OpenStruct.new(content: "Test content")
    post.define_singleton_method(:model_name) do
      OpenStruct.new(param_key: "post")
    end

    output = render(FormTextarea.new(:content, model: post, object_name: "post"))
    assert_match(%r{<textarea.+>Test content</textarea>}, output)
    assert_match(/name="post\[content\]"/, output)
    assert_match(/id="post_content"/, output)
  end

  def test_it_should_render_form_textarea_with_label
    output = render(FormTextarea.new(:content, label: "Post Content"))
    assert_match(%r{<label.+>Post Content</label>}, output)
  end

  def test_it_should_render_form_textarea_with_hint
    output = render(FormTextarea.new(:content, hint: "Enter the content of your post"))
    assert_match(/Enter the content of your post/, output)
  end

  def test_it_should_render_form_textarea_with_error
    post = OpenStruct.new(content: nil)
    post.define_singleton_method(:model_name) do
      OpenStruct.new(param_key: "post")
    end
    post.define_singleton_method(:errors) do
      OpenStruct.new(messages: { content: ["can't be blank"] })
    end

    output = render(FormTextarea.new(:content, model: post, object_name: "post"))
    assert_match(/can't be blank/, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(FormTextarea.new(
      :content,
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
