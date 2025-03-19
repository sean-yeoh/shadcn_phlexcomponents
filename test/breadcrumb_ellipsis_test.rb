# frozen_string_literal: true

require "test_helper"

class BreadcrumbEllipsisTest < ComponentTest
  def test_it_should_render_breadcrumb_ellipsis
    output = render(BreadcrumbEllipsis.new)
    assert_match(%r{<span.+<svg.+</svg></span>}, output)
    assert_match(/role="presentation"/, output)
    assert_match(/aria-hidden="true"/, output)
  end

  def test_it_should_render_base_styles
    output = render(BreadcrumbEllipsis.new)
    assert_includes(output, BreadcrumbEllipsis::STYLES.split("\n").join(" "))
  end

  def test_it_should_accept_custom_attributes
    output = render(BreadcrumbEllipsis.new(
      class: "test-class",
      data: { action: "test-action" },
    ))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
