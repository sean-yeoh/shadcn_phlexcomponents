# frozen_string_literal: true

require "test_helper"

class BreadcrumbSeparatorTest < ComponentTest
  def test_it_should_render_breadcrumb_separator
    output = render(BreadcrumbSeparator.new)
    assert_match(%r{<li.+<svg.+</svg></li>}, output)
    assert_match(/role="presentation"/, output)
    assert_match(/aria-hidden="true"/, output)
  end

  def test_it_should_render_base_styles
    output = render(BreadcrumbSeparator.new)
    assert_includes(output, BreadcrumbSeparator::STYLES.split("\n").join(" "))
  end

  def test_it_should_render_custom_icon
    output = render(BreadcrumbSeparator.new { "/" })
    assert_equal(output, "<li role=\"presentation\" aria-hidden=\"true\" class=\"[&>svg]:w-3.5 [&>svg]:h-3.5\">/</li>")
  end

  def test_it_should_accept_custom_attributes
    output = render(BreadcrumbSeparator.new(
      class: "test-class",
      data: { action: "test-action" },
    ))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
