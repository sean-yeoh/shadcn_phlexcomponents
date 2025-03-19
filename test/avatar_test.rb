# frozen_string_literal: true

require "test_helper"

class AvatarTest < ComponentTest
  def test_it_should_render_avatar
    output = render(Avatar.new)
    assert_match(%r{<span.+</span>}, output)
    assert_match(/data-controller="shadcn-phlexcomponents--avatar"/, output)
  end

  def test_it_should_render_base_styles
    output = render(Avatar.new)
    assert_includes(output, Avatar::STYLES.split("\n").join(" "))
  end

  def test_it_should_render_image
    avatar = Avatar.new do |a|
      a.image(src: "https://github.com/shadcn.png")
    end

    output = render(avatar)
    assert_match(%r{src="https://github.com/shadcn.png"}, output)
  end

  def test_it_should_render_fallback
    avatar = Avatar.new do |a|
      a.fallback { "Fallback text" }
    end

    output = render(avatar)
    assert_match(/Fallback text/, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(Avatar.new(
      class: "test-class",
      data: { action: "test-action", controller: "test-controller" },
    ))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
    assert_match(/data-controller="shadcn-phlexcomponents--avatar test-controller"/, output)
  end
end
