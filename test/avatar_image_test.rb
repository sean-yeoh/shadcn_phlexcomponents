# frozen_string_literal: true

require "test_helper"

class AvatarImageTest < ComponentTest
  def test_it_should_render_avatar_fallback
    output = render(AvatarImage.new(src: "https://github.com/shadcn.png"))
    assert_match(/<img.+>/, output)
    assert_includes(output, "https://github.com/shadcn.png")
    assert_match(/data-shadcn-phlexcomponents--avatar-target="image"/, output)
  end

  def test_it_should_render_base_styles
    output = render(AvatarImage.new)
    assert_includes(output, AvatarImage::STYLES.split("\n").join(" "))
  end

  def test_it_should_accept_custom_attributes
    output = render(AvatarImage.new(
      class: "test-class",
      data: { action: "test-action" },
    ))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
