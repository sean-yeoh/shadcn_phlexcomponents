# frozen_string_literal: true

require "test_helper"

class InputTest < ComponentTest
  def test_it_should_render_input
    output = render(Input.new)
    assert_match(/<input.+>/, output)
    assert_match(/type="text"/, output)
  end

  def test_it_should_render_base_styles
    output = render(Input.new)
    assert_includes(output, Input::STYLES.split("\n").join(" "))
  end

  def test_it_should_render_type
    output = render(Input.new(type: :email))
    assert_match(/type="email"/, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(Input.new(placeholder: "Input placeholder", class: "test-class", data: { action: "test-action" }))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
    assert_match(/placeholder="Input placeholder"/, output)
  end

  def test_it_should_assign_name_to_id_if_id_is_nil
    output = render(Input.new(name: "my-input"))
    assert_match(/id="my-input"/, output)
    assert_match(/name="my-input"/, output)
  end

  def test_it_should_not_assign_name_to_id_if_id_is_present
    output = render(Input.new(id: "username", name: "my-input"))
    refute_match(/id="my-input"/, output)
    assert_match(/id="username"/, output)
    assert_match(/name="my-input"/, output)
  end
end
