# frozen_string_literal: true

require "test_helper"

class LoadingButtonTest < ComponentTest
  def test_it_should_render_loading_button
    output = render(LoadingButton.new { "Loading Button" })
    assert_match(%r{<button.+<svg.+</svg>Loading Button</button>}, output)
    assert_match(/type="button"/, output)
    assert_match(/data-controller="shadcn-phlexcomponents--loading-button"/, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(LoadingButton.new(
      class: "test-class",
      data: { action: "test-action", controller: "test-controller" },
    ) { "Loading Button" })
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
    assert_match(/data-controller="shadcn-phlexcomponents--loading-button test-controller"/, output)
  end
end
