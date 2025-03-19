# frozen_string_literal: true

require "test_helper"

class BreadcrumbItemTest < ComponentTest
  def test_it_should_render_breadcrumb_item
    output = render(BreadcrumbItem.new { "Breadcrumb item" })
    assert_match(%r{<li.+</li>}, output)
    assert_match(/Breadcrumb item/, output)
  end

  def test_it_should_render_base_styles
    output = render(BreadcrumbItem.new)
    assert_includes(output, BreadcrumbItem::STYLES.split("\n").join(" "))
  end

  def test_it_should_accept_custom_attributes
    output = render(BreadcrumbItem.new(
      class: "test-class",
      data: { action: "test-action" },
    ))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
