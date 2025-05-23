# frozen_string_literal: true

require "test_helper"

class ProgressTest < ComponentTest
  def test_it_should_render_progress
    output = render(Progress.new(value: 50))
    assert_match(%r{<div.+role="progressbar".+</div>}, output)
    assert_match(/data-controller="progress"/, output)
    assert_match(/aria-valuemin="0"/, output)
    assert_match(/aria-valuemax="100"/, output)
    assert_match(/aria-valuenow="50"/, output)
    assert_match(/data-progress-progress-value="50"/, output)
  end

  def test_it_should_render_progress_with_zero_value
    output = render(Progress.new(value: 0))
    assert_match(/aria-valuenow="0"/, output)
    assert_match(/data-progress-progress-value="0"/, output)
    assert_match(/transform: translateX\(-100%\)/, output)
  end

  def test_it_should_render_progress_with_full_value
    output = render(Progress.new(value: 100))
    assert_match(/aria-valuenow="100"/, output)
    assert_match(/data-progress-progress-value="100"/, output)
    assert_match(/transform: translateX\(-0%\)/, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(Progress.new(
      value: 50,
      class: "test-class",
      data: { action: "test-action" },
    ))

    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
