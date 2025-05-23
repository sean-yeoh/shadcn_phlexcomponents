# frozen_string_literal: true

require "test_helper"

class SkeletonTest < ComponentTest
  def test_it_should_render_skeleton
    output = render(Skeleton.new)
    assert_match(%r{<div.+</div>}, output)
    assert_match(/animate-pulse/, output)
    assert_match(/rounded-md/, output)
    assert_match(%r{bg-primary/10}, output)
  end

  def test_it_should_render_skeleton_with_content
    output = render(Skeleton.new) { "Loading..." }
    assert_match(/Loading.../, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(Skeleton.new(
      class: "test-class",
      data: { action: "test-action" },
    ))

    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
