# frozen_string_literal: true

require "test_helper"

class AlertTest < ComponentTest
  def test_it_should_render_a_default_alert
    output = render(Alert.new)
    assert_match(%r{<div.+</div>}, output)
    assert_includes(output, Alert::VARIANTS[:default])
    assert_match(/role="alert"/, output)
  end

  def test_it_should_render_base_styles
    output = render(Alert.new)
    assert_includes(output, Alert::STYLES.split("\n").join(" "))
  end

  def test_it_should_render_variants
    Alert::VARIANTS.each do |variant, variant_styles|
      output = render(Alert.new(variant: variant))
      assert_includes(output, variant_styles)
    end
  end

  def test_it_should_render_title
    alert = Alert.new do |a|
      a.title { "Alert title" }
    end

    output = render(alert)
    assert_includes(output, "Alert title")
  end

  def test_it_should_render_description
    alert = Alert.new do |a|
      a.description { "Alert description" }
    end

    output = render(alert)
    assert_includes(output, "Alert description")
  end

  def test_it_should_accept_custom_attributes
    output = render(Alert.new(class: "test-class", data: { action: "test-action" }))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
