# frozen_string_literal: true

require "test_helper"

class AlertTitleTest < ComponentTest
  def test_it_should_render_an_alert_title
    output = render(AlertTitle.new { "Alert title" })
    assert_match(%r{<div.+</div>}, output)
    assert_includes(output, "Alert title")
  end

  def test_it_should_render_base_styles
    output = render(AlertTitle.new)
    assert_includes(output, AlertTitle::STYLES.split("\n").join(" "))
  end

  def test_it_should_accept_custom_attributes
    output = render(AlertTitle.new(class: "bg-red-100 text-red-500", data: { action: "click->controller#onClick" }))
    assert_match(/bg-red-100 text-red-500/, output)
    assert_match(/data-action="click->controller#onClick"/, output)
  end
end
