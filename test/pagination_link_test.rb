# frozen_string_literal: true

require "test_helper"

class PaginationLinkTest < ComponentTest
  def test_it_should_render_pagination_link
    output = render(PaginationLink.new(href: "/page/1") { "1" })
    assert_match(%r{<a.+</a>}, output)
    assert_match(%r{href="/page/1"}, output)
    assert_match(/1/, output)
  end

  def test_it_should_render_pagination_link_with_current_page
    output = render(PaginationLink.new(href: "/page/1", "aria-current": "page") { "1" })
    assert_match(/aria-current="page"/, output)
    assert_match(/bg-primary/, output)
    assert_match(/text-primary-foreground/, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(PaginationLink.new(
      href: "/page/1",
      class: "test-class",
      data: { action: "test-action" },
    ) { "1" })

    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
