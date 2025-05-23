# frozen_string_literal: true

require "test_helper"

class FormInputTest < ComponentTest
  def test_it_should_render_form_input
    output = render(FormInput.new(:title))
    assert_match(%r{<input.+/>}, output)
    assert_match(/name="title"/, output)
    assert_match(/id="title"/, output)
  end

  def test_it_should_render_form_input_with_model
    post = OpenStruct.new(title: "Test Post")
    post.define_singleton_method(:model_name) do
      OpenStruct.new(param_key: "post")
    end

    output = render(FormInput.new(:title, model: post, object_name: "post"))
    assert_match(%r{<input.+/>}, output)
    assert_match(/name="post\[title\]"/, output)
    assert_match(/id="post_title"/, output)
    assert_match(/value="Test Post"/, output)
  end

  def test_it_should_render_form_input_with_label
    output = render(FormInput.new(:title, label: "Post Title"))
    assert_match(%r{<label.+>Post Title</label>}, output)
  end

  def test_it_should_render_form_input_with_hint
    output = render(FormInput.new(:title, hint: "Enter the title of your post"))
    assert_match(/Enter the title of your post/, output)
  end

  def test_it_should_render_form_input_with_error
    post = OpenStruct.new(title: nil)
    post.define_singleton_method(:model_name) do
      OpenStruct.new(param_key: "post")
    end
    post.define_singleton_method(:errors) do
      OpenStruct.new(messages: { title: ["can't be blank"] })
    end

    output = render(FormInput.new(:title, model: post, object_name: "post"))
    assert_match(/can't be blank/, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(FormInput.new(
      :title,
      class: "test-class",
      data: { action: "test-action" },
      placeholder: "Enter title",
    ))

    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
    assert_match(/placeholder="Enter title"/, output)
  end
end
