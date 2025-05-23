# frozen_string_literal: true

require "test_helper"

class FormTest < ComponentTest
  def test_it_should_render_form
    output = render(Form.new(url: "/posts"))
    assert_match(%r{<form.+</form>}, output)
    assert_match(%r{action="/posts"}, output)
    assert_match(/method="post"/, output)
  end

  def test_it_should_render_form_with_model
    post = OpenStruct.new(id: 1, title: "Test Post", persisted?: true)
    post.define_singleton_method(:model_name) do
      OpenStruct.new(param_key: "post", human: "Post", i18n_key: "post")
    end
    post.define_singleton_method(:to_model) { post }

    output = render(Form.new(model: post, url: "/posts/1"))
    assert_match(%r{<form.+</form>}, output)
    assert_match(%r{action="/posts/1"}, output)
  end

  def test_it_should_render_form_with_loading_state
    output = render(Form.new(url: "/posts", loading: true))
    assert_match(/group/, output)
  end

  def test_it_should_render_submit_button
    output = render(Form.new(url: "/posts")) do |form|
      form.submit("Save Post")
    end

    assert_match(%r{<button.+type="submit".+>Save Post</button>}, output)
  end

  def test_it_should_render_loading_submit_button_when_loading_is_true
    output = render(Form.new(url: "/posts", loading: true)) do |form|
      form.submit("Save Post")
    end

    assert_match(%r{<button.+data-controller="loading-button".+>Save Post</button>}, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(Form.new(
      url: "/posts",
      class: "test-class",
      data: { action: "test-action" },
    ))

    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
