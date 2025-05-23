# frozen_string_literal: true

require "test_helper"

class PaginationPreviousTest < ComponentTest
  def test_it_should_render_pagination_previous
    output = render(PaginationPrevious.new(href: "/page/1") { "Previous" })
    assert_match(%r{<a.+</a>}, output)
    assert_match(%r{href="/page/1"}, output)
    assert_match(/Previous/, output)
  end

  def test_it_should_render_pagination_previous_with_icon
    output = render(PaginationPrevious.new(href: "/page/1"))
    assert_match(/svg/, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(PaginationPrevious.new(
      href: "/page/1",
      class: "test-class",
      data: { action: "test-action" },
    ) { "Previous" })

    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
