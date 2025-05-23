# frozen_string_literal: true

require "test_helper"

class PopoverTest < ComponentTest
  def test_it_should_render_popover
    output = render(Popover.new) do |popover|
      popover.trigger { "Click me" }
      popover.content { "Popover content" }
    end

    assert_match(%r{<div.+data-controller="popover".+</div>}, output)
    assert_match(/Click me/, output)
    assert_match(/Popover content/, output)
  end

  def test_it_should_render_popover_with_custom_side
    output = render(Popover.new(side: :top)) do |popover|
      popover.trigger { "Click me" }
      popover.content { "Popover content" }
    end

    assert_match(/data-side="top"/, output)
  end

  def test_it_should_render_popover_with_custom_aria_id
    output = render(Popover.new(aria_id: "custom-popover")) do |popover|
      popover.trigger { "Click me" }
      popover.content { "Popover content" }
    end

    assert_match(/id="custom-popover"/, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(Popover.new(
      class: "test-class",
      data: { action: "test-action" },
    ))

    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
