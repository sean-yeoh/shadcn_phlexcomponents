# frozen_string_literal: true

require "test_helper"

class AlertTitleTest < ComponentTest
  def test_it_should_render_alert_title
    output = render(AlertTitle.new { "Alert title" })
    assert_match(%r{<div.+</div>}, output)
    assert_match(/Alert title/, output)
  end

  def test_it_should_render_base_styles
    output = render(AlertTitle.new)
    assert_includes(output, AlertTitle::STYLES.split("\n").join(" "))
  end

  def test_it_should_accept_custom_attributes
    output = render(AlertTitle.new(class: "test-class", data: { action: "test-action" }))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
