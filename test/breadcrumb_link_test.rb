# frozen_string_literal: true

require "test_helper"

class BreadcrumbLinkTest < ComponentTest
  def test_it_should_render_breadcrumb_link
    output = render(BreadcrumbLink.new("My posts", Rails.application.routes.url_helpers.posts_path))

    assert_match(%r{<a.+</a>}, output)
    assert_includes(output, BreadcrumbLink::STYLES)
    assert_match(/My posts/, output)
    assert_match(%r{href="/posts"}, output)
  end
end
