# frozen_string_literal: true

require "test_helper"

class LinkTest < ComponentTest
  def test_it_should_render_link
    output = render(Link.new("My posts", Rails.application.routes.url_helpers.posts_path))

    assert_match(%r{<a.+</a>}, output)
    assert_includes(output, Link::STYLES)
    assert_match(/My posts/, output)
    assert_match(%r{href="/posts"}, output)
  end
end
