# frozen_string_literal: true

require "test_helper"

class CardTest < ComponentTest
  def test_it_should_render_card
    output = render(Card.new)
    assert_match(%r{<div.+</div>}, output)
  end

  def test_it_should_render_base_styles
    output = render(Card.new)
    assert_includes(output, Card::STYLES.split("\n").join(" "))
  end

  def test_it_should_render_header
    card = Card.new do |c|
      c.header { "Card header" }
    end

    output = render(card)
    assert_match(/Card header/, output)
  end

  def test_it_should_render_title
    card = Card.new do |c|
      c.title { "Card title" }
    end

    output = render(card)
    assert_match(/Card title/, output)
  end

  def test_it_should_render_description
    card = Card.new do |c|
      c.description { "Card description" }
    end

    output = render(card)
    assert_match(/Card description/, output)
  end

  def test_it_should_render_content
    card = Card.new do |c|
      c.content { "Card content" }
    end

    output = render(card)
    assert_match(/Card content/, output)
  end

  def test_it_should_render_footer
    card = Card.new do |c|
      c.footer { "Card footer" }
    end

    output = render(card)
    assert_match(/Card footer/, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(Card.new(
      class: "test-class",
      data: { action: "test-action" },
    ))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
