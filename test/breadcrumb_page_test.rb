# frozen_string_literal: true

require "test_helper"

class BreadcrumbPageTest < ComponentTest
  def test_it_should_render_breadcrumb_page
    output = render(BreadcrumbPage.new { "Breadcrumb page" })
    assert_match(%r{<span.+</span>}, output)
    assert_match(/role="link"/, output)
    assert_match(/aria-disabled="true"/, output)
    assert_match(/aria-current="page"/, output)
    assert_match(/Breadcrumb page/, output)
  end

  def test_it_should_render_base_styles
    output = render(BreadcrumbPage.new)
    assert_includes(output, BreadcrumbPage::STYLES.split("\n").join(" "))
  end

  def test_it_should_accept_custom_attributes
    output = render(BreadcrumbPage.new(
      class: "test-class",
      data: { action: "test-action" },
    ))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
