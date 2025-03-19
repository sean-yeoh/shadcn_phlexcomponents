# frozen_string_literal: true

require "test_helper"

class AvatarFallbackTest < ComponentTest
  def test_it_should_render_an_avatar_fallback
    output = render(AvatarFallback.new { "Fallback text" })
    assert_match(%r{<span.+</span>}, output)
    assert_includes(output, "Fallback text")
    assert_match(/data-shadcn-phlexcomponents--avatar-target="fallback"/, output)
  end

  def test_it_should_render_base_styles
    output = render(AvatarFallback.new)
    assert_includes(output, AvatarFallback::STYLES.split("\n").join(" "))
  end

  def test_it_should_accept_custom_attributes
    output = render(AvatarFallback.new(
      class: "test-class",
      data: { action: "test-action" },
    ))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
