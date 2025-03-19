# frozen_string_literal: true

require "test_helper"

class BaseComponentTest < ComponentTest
  def test_nokogiri_attributes_to_hash
    output = render(Button.new)
    element = BaseComponent.new.find_as_child(output)
    hash = BaseComponent.new.nokogiri_attributes_to_hash(element)
    assert_equal([:type, :class], hash.keys)
  end

  def test_find_as_child
    output = render(Button.new)
    element = BaseComponent.new.find_as_child(output)
    assert_equal(element.name, "button")
  end
end
