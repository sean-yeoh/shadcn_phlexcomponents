# frozen_string_literal: true

require "test_helper"

class AlertDescriptionTest < ComponentTest
  def test_it_should_render_alert_description
    output = render(AlertDescription.new { "Alert description" })
    assert_match(%r{<div.+</div>}, output)
    assert_match("Alert description", output)
  end

  def test_it_should_render_base_styles
    output = render(AlertDescription.new)
    assert_includes(output, AlertDescription::STYLES.split("\n").join(" "))
  end

  def test_it_should_accept_custom_attributes
    output = render(AlertDescription.new(
      class: "test-class",
      data: { action: "test-action" },
    ))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
