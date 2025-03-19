# frozen_string_literal: true

require "test_helper"

class LinkTest < ComponentTest
  # No idea why link_to is nil when testing, so had to stub it.
  def test_it_should_render_a_link
    link = Link.new("My posts", Rails.application.routes.url_helpers.posts_path)

    def link.view_context
      controller.view_context
    end

    def link.controller
      @controller ||= ActionView::TestCase::TestController.new
    end

    def link.render
      link_to(@name, @options, @html_options)
    end

    def link.link_to(name, options, html_options)
      view_context.link_to(name, options, html_options)
    end

    output = link.render
    assert_match(%r{<a.+</a>}, output)
    assert_includes(output, Link::STYLES)
    assert_includes(output, "My posts")
    assert_match(%r{href="/posts"}, output)
  end
end
