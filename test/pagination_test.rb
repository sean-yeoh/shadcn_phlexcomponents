# frozen_string_literal: true

require "test_helper"

class PaginationTest < ComponentTest
  def test_it_should_render_pagination
    output = render(Pagination.new) do |pagination|
      pagination.link(href: "/page/1", "aria-current": "page") { "1" }
      pagination.link(href: "/page/2") { "2" }
      pagination.link(href: "/page/3") { "3" }
    end

    assert_match(%r{<div.+role="navigation".+</div>}, output)
    assert_match(%r{<ul.+</ul>}, output)
    assert_match(%r{<a.+href="/page/1".+aria-current="page".+>1</a>}, output)
    assert_match(%r{<a.+href="/page/2".+>2</a>}, output)
    assert_match(%r{<a.+href="/page/3".+>3</a>}, output)
  end

  def test_it_should_render_pagination_with_previous_and_next
    output = render(Pagination.new) do |pagination|
      pagination.previous(href: "/page/1") { "Previous" }
      pagination.link(href: "/page/1") { "1" }
      pagination.link(href: "/page/2", "aria-current": "page") { "2" }
      pagination.link(href: "/page/3") { "3" }
      pagination.next(href: "/page/3") { "Next" }
    end

    assert_match(/Previous/, output)
    assert_match(/Next/, output)
  end

  def test_it_should_render_pagination_with_ellipsis
    output = render(Pagination.new) do |pagination|
      pagination.previous(href: "/page/1") { "Previous" }
      pagination.link(href: "/page/1") { "1" }
      pagination.ellipsis
      pagination.link(href: "/page/10", "aria-current": "page") { "10" }
      pagination.link(href: "/page/11") { "11" }
      pagination.next(href: "/page/11") { "Next" }
    end

    assert_match(/Previous/, output)
    assert_match(/…/, output)
    assert_match(/Next/, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(Pagination.new(
      class: "test-class",
      data: { action: "test-action" },
    ))

    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
