# frozen_string_literal: true

require "test_helper"

class PaginationEllipsisTest < ComponentTest
  def test_it_should_render_pagination_ellipsis
    output = render(PaginationEllipsis.new)
    assert_match(%r{<span.+</span>}, output)
    assert_match(/…/, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(PaginationEllipsis.new(
      class: "test-class",
      data: { action: "test-action" },
    ))

    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
