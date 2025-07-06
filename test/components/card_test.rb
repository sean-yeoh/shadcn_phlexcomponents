# frozen_string_literal: true

require "test_helper"

class CardTest < ComponentTestCase
  def test_renders_basic_card
    component = ShadcnPhlexcomponents::Card.new { "Card content" }
    html = assert_component_renders(component)

    assert_has_tag(html, "div")
    assert_has_content(html, "Card content")
  end

  def test_card_base_classes
    component = ShadcnPhlexcomponents::Card.new { "Test" }
    html = assert_component_renders(component)

    assert_has_class(html, "bg-card")
    assert_has_class(html, "text-card-foreground")
    assert_has_class(html, "flex")
    assert_has_class(html, "flex-col")
    assert_has_class(html, "gap-6")
    assert_has_class(html, "rounded-xl")
    assert_has_class(html, "border")
    assert_has_class(html, "py-6")
    assert_has_class(html, "shadow-sm")
  end

  def test_card_header_helper
    component = ShadcnPhlexcomponents::Card.new do
      header { "Header content" }
    end
    html = assert_component_renders(component)

    assert_has_content(html, "Header content")
    assert_has_attribute(html, "data-shadcn-phlexcomponents", "card-header")
  end

  def test_card_title_helper
    component = ShadcnPhlexcomponents::Card.new do
      title { "Card Title" }
    end
    html = assert_component_renders(component)

    assert_has_content(html, "Card Title")
    assert_has_attribute(html, "data-shadcn-phlexcomponents", "card-title")
  end

  def test_card_description_helper
    component = ShadcnPhlexcomponents::Card.new do
      description { "Card description" }
    end
    html = assert_component_renders(component)

    assert_has_content(html, "Card description")
    assert_has_attribute(html, "data-shadcn-phlexcomponents", "card-description")
  end

  def test_card_content_helper
    component = ShadcnPhlexcomponents::Card.new do
      content { "Main content" }
    end
    html = assert_component_renders(component)

    assert_has_content(html, "Main content")
    assert_has_attribute(html, "data-shadcn-phlexcomponents", "card-content")
  end

  def test_card_footer_helper
    component = ShadcnPhlexcomponents::Card.new do
      footer { "Footer content" }
    end
    html = assert_component_renders(component)

    assert_has_content(html, "Footer content")
    assert_has_attribute(html, "data-shadcn-phlexcomponents", "card-footer")
  end

  def test_card_action_helper
    component = ShadcnPhlexcomponents::Card.new do
      action { "Action" }
    end
    html = assert_component_renders(component)

    assert_has_content(html, "Action")
    assert_has_attribute(html, "data-shadcn-phlexcomponents", "card-action")
  end

  def test_complex_card_structure
    component = ShadcnPhlexcomponents::Card.new do
      header do
        title { "Card Title" }
        description { "Card description" }
        action { "..." }
      end
      content { "Main content here" }
      footer { "Footer text" }
    end
    html = assert_component_renders(component)

    assert_has_content(html, "Card Title")
    assert_has_content(html, "Card description")
    assert_has_content(html, "Main content here")
    assert_has_content(html, "Footer text")
  end

  def test_data_attribute_added
    component = ShadcnPhlexcomponents::Card.new { "Test" }
    html = assert_component_renders(component)

    assert_has_attribute(html, "data-shadcn-phlexcomponents", "card")
  end
end

class CardHeaderTest < ComponentTestCase
  def test_renders_card_header
    component = ShadcnPhlexcomponents::CardHeader.new { "Header" }
    html = assert_component_renders(component)

    assert_has_tag(html, "div")
    assert_has_content(html, "Header")
  end

  def test_card_header_classes
    component = ShadcnPhlexcomponents::CardHeader.new { "Test" }
    html = assert_component_renders(component)

    assert_has_class(html, "grid")
    assert_has_class(html, "auto-rows-min")
    assert_has_class(html, "items-start")
    assert_has_class(html, "gap-1.5")
    assert_has_class(html, "px-6")
  end
end

class CardTitleTest < ComponentTestCase
  def test_renders_card_title
    component = ShadcnPhlexcomponents::CardTitle.new { "Title" }
    html = assert_component_renders(component)

    assert_has_tag(html, "div")
    assert_has_content(html, "Title")
  end

  def test_card_title_classes
    component = ShadcnPhlexcomponents::CardTitle.new { "Test" }
    html = assert_component_renders(component)

    assert_has_class(html, "leading-none")
    assert_has_class(html, "font-semibold")
  end
end

class CardDescriptionTest < ComponentTestCase
  def test_renders_card_description
    component = ShadcnPhlexcomponents::CardDescription.new { "Description" }
    html = assert_component_renders(component)

    assert_has_tag(html, "div")
    assert_has_content(html, "Description")
  end

  def test_card_description_classes
    component = ShadcnPhlexcomponents::CardDescription.new { "Test" }
    html = assert_component_renders(component)

    assert_has_class(html, "text-muted-foreground")
    assert_has_class(html, "text-sm")
  end
end

class CardContentTest < ComponentTestCase
  def test_renders_card_content
    component = ShadcnPhlexcomponents::CardContent.new { "Content" }
    html = assert_component_renders(component)

    assert_has_tag(html, "div")
    assert_has_content(html, "Content")
  end

  def test_card_content_classes
    component = ShadcnPhlexcomponents::CardContent.new { "Test" }
    html = assert_component_renders(component)

    assert_has_class(html, "px-6")
  end
end

class CardFooterTest < ComponentTestCase
  def test_renders_card_footer
    component = ShadcnPhlexcomponents::CardFooter.new { "Footer" }
    html = assert_component_renders(component)

    assert_has_tag(html, "div")
    assert_has_content(html, "Footer")
  end

  def test_card_footer_classes
    component = ShadcnPhlexcomponents::CardFooter.new { "Test" }
    html = assert_component_renders(component)

    assert_has_class(html, "flex")
    assert_has_class(html, "items-center")
    assert_has_class(html, "px-6")
  end
end

class CardActionTest < ComponentTestCase
  def test_renders_card_action
    component = ShadcnPhlexcomponents::CardAction.new { "Action" }
    html = assert_component_renders(component)

    assert_has_tag(html, "div")
    assert_has_content(html, "Action")
  end

  def test_card_action_classes
    component = ShadcnPhlexcomponents::CardAction.new { "Test" }
    html = assert_component_renders(component)

    assert_has_class(html, "col-start-2")
    assert_has_class(html, "row-span-2")
    assert_has_class(html, "row-start-1")
    assert_has_class(html, "self-start")
    assert_has_class(html, "justify-self-end")
  end
end
