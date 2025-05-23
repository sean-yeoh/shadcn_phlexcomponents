# frozen_string_literal: true

require "test_helper"

class PaginationNextTest < ComponentTest
  def test_it_should_render_pagination_next
    output = render(PaginationNext.new(href: "/page/2") { "Next" })
    assert_match(%r{<a.+</a>}, output)
    assert_match(%r{href="/page/2"}, output)
    assert_match(/Next/, output)
  end

  def test_it_should_render_pagination_next_with_icon
    output = render(PaginationNext.new(href: "/page/2"))
    assert_match(/svg/, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(PaginationNext.new(
      href: "/page/2",
      class: "test-class",
      data: { action: "test-action" },
    ) { "Next" })

    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
