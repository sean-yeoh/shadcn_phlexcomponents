# frozen_string_literal: true

require "test_helper"

class TestCard < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::Card.new { "Card content" }
    output = render(component)

    assert_includes(output, "bg-card text-card-foreground flex flex-col gap-6 rounded-xl border py-6 shadow-sm")
    assert_includes(output, "Card content")
    assert_match(%r{<div[^>]*>Card content</div>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Card.new(class: "card-class", id: "card-id", data: { testid: "card" })
    output = render(component)

    assert_includes(output, "card-class")
    assert_includes(output, 'id="card-id"')
    assert_includes(output, 'data-testid="card"')
    assert_includes(output, "bg-card text-card-foreground")
  end

  def test_it_should_render_with_header
    component = ShadcnPhlexcomponents::Card.new do |card|
      card.header { "Card Header" }
    end
    output = render(component)

    assert_includes(output, "Card Header")
    assert_includes(output, "@container/card-header grid auto-rows-min grid-rows-[auto_auto] items-start gap-1.5")
    assert_includes(output, "px-6")
  end

  def test_it_should_render_with_title_and_description
    component = ShadcnPhlexcomponents::Card.new do |card|
      card.header do
        card.title { "Card Title" }
        card.description { "Card description text" }
      end
    end
    output = render(component)

    assert_includes(output, "Card Title")
    assert_includes(output, "Card description text")
    assert_includes(output, "leading-none font-semibold")
    assert_includes(output, "text-muted-foreground text-sm")
  end

  def test_it_should_render_with_content
    component = ShadcnPhlexcomponents::Card.new do |card|
      card.content { "Main card content goes here" }
    end
    output = render(component)

    assert_includes(output, "Main card content goes here")
    assert_includes(output, "px-6")
  end

  def test_it_should_render_with_footer
    component = ShadcnPhlexcomponents::Card.new do |card|
      card.footer { "Card footer actions" }
    end
    output = render(component)

    assert_includes(output, "Card footer actions")
    assert_includes(output, "flex items-center px-6 [.border-t]:pt-6")
  end

  def test_it_should_render_with_action
    component = ShadcnPhlexcomponents::Card.new do |card|
      card.header do
        card.title { "Title" }
        card.action { "⋮" }
      end
    end
    output = render(component)

    assert_includes(output, "Title")
    assert_includes(output, "⋮")
    assert_includes(output, "col-start-2 row-span-2 row-start-1 self-start justify-self-end")
    assert_includes(output, "has-data-[shadcn-phlexcomponents=card-action]:grid-cols-[1fr_auto]")
  end

  def test_it_should_render_complete_card_structure
    component = ShadcnPhlexcomponents::Card.new do |card|
      card.header do
        card.title { "Project Dashboard" }
        card.description { "Overview of your current projects" }
        card.action { "⚙️" }
      end
      card.content { "Dashboard content with charts and metrics" }
      card.footer { "Last updated: 2 minutes ago" }
    end
    output = render(component)

    # Check main card
    assert_includes(output, "bg-card text-card-foreground flex flex-col gap-6")

    # Check header with title, description, and action
    assert_includes(output, "Project Dashboard")
    assert_includes(output, "Overview of your current projects")
    assert_includes(output, "⚙️")

    # Check content
    assert_includes(output, "Dashboard content with charts and metrics")

    # Check footer
    assert_includes(output, "Last updated: 2 minutes ago")
  end
end

class TestCardHeader < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::CardHeader.new { "Header content" }
    output = render(component)

    assert_includes(output, "Header content")
    assert_includes(output, "@container/card-header grid auto-rows-min grid-rows-[auto_auto] items-start gap-1.5")
    assert_includes(output, "px-6 has-data-[shadcn-phlexcomponents=card-action]:grid-cols-[1fr_auto]")
    assert_match(%r{<div[^>]*>Header content</div>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::CardHeader.new(class: "header-class", id: "header-id")
    output = render(component)

    assert_includes(output, "header-class")
    assert_includes(output, 'id="header-id"')
    assert_includes(output, "@container/card-header grid")
  end

  def test_it_should_handle_border_modifier
    component = ShadcnPhlexcomponents::CardHeader.new(class: "border-b") { "Bordered header" }
    output = render(component)

    assert_includes(output, "border-b")
    assert_includes(output, "[.border-b]:pb-6")
    assert_includes(output, "Bordered header")
  end
end

class TestCardTitle < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::CardTitle.new { "Card Title" }
    output = render(component)

    assert_includes(output, "Card Title")
    assert_includes(output, "leading-none font-semibold")
    assert_match(%r{<div[^>]*>Card Title</div>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::CardTitle.new(class: "title-class", id: "title-id")
    output = render(component)

    assert_includes(output, "title-class")
    assert_includes(output, 'id="title-id"')
    assert_includes(output, "leading-none font-semibold")
  end
end

class TestCardDescription < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::CardDescription.new { "Card description" }
    output = render(component)

    assert_includes(output, "Card description")
    assert_includes(output, "text-muted-foreground text-sm")
    assert_match(%r{<div[^>]*>Card description</div>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::CardDescription.new(class: "description-class", id: "description-id")
    output = render(component)

    assert_includes(output, "description-class")
    assert_includes(output, 'id="description-id"')
    assert_includes(output, "text-muted-foreground text-sm")
  end
end

class TestCardAction < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::CardAction.new { "Action button" }
    output = render(component)

    assert_includes(output, "Action button")
    assert_includes(output, "col-start-2 row-span-2 row-start-1 self-start justify-self-end")
    assert_match(%r{<div[^>]*>Action button</div>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::CardAction.new(class: "action-class", id: "action-id")
    output = render(component)

    assert_includes(output, "action-class")
    assert_includes(output, 'id="action-id"')
    assert_includes(output, "col-start-2 row-span-2 row-start-1")
  end
end

class TestCardContent < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::CardContent.new { "Main content" }
    output = render(component)

    assert_includes(output, "Main content")
    assert_includes(output, "px-6")
    assert_match(%r{<div[^>]*>Main content</div>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::CardContent.new(class: "content-class", id: "content-id")
    output = render(component)

    assert_includes(output, "content-class")
    assert_includes(output, 'id="content-id"')
    assert_includes(output, "px-6")
  end

  def test_it_should_have_empty_base_class_variant
    # CardContent has an unusual `class_variants(base: "")` which should not interfere
    component = ShadcnPhlexcomponents::CardContent.new(class: "custom-class") { "Content" }
    output = render(component)

    assert_includes(output, "custom-class")
    assert_includes(output, "px-6")
    assert_includes(output, "Content")
  end
end

class TestCardFooter < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::CardFooter.new { "Footer content" }
    output = render(component)

    assert_includes(output, "Footer content")
    assert_includes(output, "flex items-center px-6 [.border-t]:pt-6")
    assert_match(%r{<div[^>]*>Footer content</div>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::CardFooter.new(class: "footer-class", id: "footer-id")
    output = render(component)

    assert_includes(output, "footer-class")
    assert_includes(output, 'id="footer-id"')
    assert_includes(output, "flex items-center px-6")
  end

  def test_it_should_handle_border_modifier
    component = ShadcnPhlexcomponents::CardFooter.new(class: "border-t") { "Bordered footer" }
    output = render(component)

    assert_includes(output, "border-t")
    assert_includes(output, "[.border-t]:pt-6")
    assert_includes(output, "Bordered footer")
  end
end

class TestCardWithCustomConfiguration < ComponentTest
  def test_card_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.card = {
      root: {
        base: "custom-card-base",
      },
      header: {
        base: "custom-header-base",
      },
      title: {
        base: "custom-title-base",
      },
      description: {
        base: "custom-description-base",
      },
      action: {
        base: "custom-action-base",
      },
      content: {
        base: "custom-content-base",
      },
      footer: {
        base: "custom-footer-base",
      },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload the Card classes to pick up the new configuration
    [
      "CardFooter",
      "CardContent",
      "CardAction",
      "CardDescription",
      "CardTitle",
      "CardHeader",
      "Card",
    ].each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/card.rb", __dir__))

    # Test Card with custom configuration
    card_component = ShadcnPhlexcomponents::Card.new { "Card" }
    card_output = render(card_component)
    assert_includes(card_output, "custom-card-base")

    # Test CardHeader with custom configuration
    header_component = ShadcnPhlexcomponents::CardHeader.new { "Header" }
    header_output = render(header_component)
    assert_includes(header_output, "custom-header-base")

    # Test CardTitle with custom configuration
    title_component = ShadcnPhlexcomponents::CardTitle.new { "Title" }
    title_output = render(title_component)
    assert_includes(title_output, "custom-title-base")

    # Test CardDescription with custom configuration
    description_component = ShadcnPhlexcomponents::CardDescription.new { "Description" }
    description_output = render(description_component)
    assert_includes(description_output, "custom-description-base")

    # Test CardAction with custom configuration
    action_component = ShadcnPhlexcomponents::CardAction.new { "Action" }
    action_output = render(action_component)
    assert_includes(action_output, "custom-action-base")

    # Test CardContent with custom configuration
    content_component = ShadcnPhlexcomponents::CardContent.new { "Content" }
    content_output = render(content_component)
    assert_includes(content_output, "custom-content-base")

    # Test CardFooter with custom configuration
    footer_component = ShadcnPhlexcomponents::CardFooter.new { "Footer" }
    footer_output = render(footer_component)
    assert_includes(footer_output, "custom-footer-base")
  ensure
    # Restore and reload classes
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    [
      "CardFooter",
      "CardContent",
      "CardAction",
      "CardDescription",
      "CardTitle",
      "CardHeader",
      "Card",
    ].each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/card.rb", __dir__))
  end
end

class TestCardIntegration < ComponentTest
  def test_complete_card_layouts
    # Simple card
    simple_card = ShadcnPhlexcomponents::Card.new do |card|
      card.content { "Simple card content" }
    end
    simple_output = render(simple_card)

    assert_includes(simple_output, "bg-card text-card-foreground")
    assert_includes(simple_output, "Simple card content")

    # Card with header and content
    header_card = ShadcnPhlexcomponents::Card.new do |card|
      card.header do
        card.title { "Dashboard" }
        card.description { "System overview" }
      end
      card.content { "📊 Chart data here" }
    end
    header_output = render(header_card)

    assert_includes(header_output, "Dashboard")
    assert_includes(header_output, "System overview")
    assert_includes(header_output, "📊 Chart data here")

    # Full card with all sections
    full_card = ShadcnPhlexcomponents::Card.new do |card|
      card.header do
        card.title { "User Profile" }
        card.description { "Manage your account settings" }
        card.action { "⚙️" }
      end
      card.content { "Profile form fields would go here" }
      card.footer { "Last updated: Today" }
    end
    full_output = render(full_card)

    assert_includes(full_output, "User Profile")
    assert_includes(full_output, "Manage your account settings")
    assert_includes(full_output, "⚙️")
    assert_includes(full_output, "Profile form fields would go here")
    assert_includes(full_output, "Last updated: Today")
  end

  def test_card_with_bordered_sections
    component = ShadcnPhlexcomponents::Card.new do |card|
      card.header(class: "border-b") do
        card.title { "Reports" }
        card.description { "View your analytics" }
      end
      card.content { "Report content with tables and charts" }
      card.footer(class: "border-t") { "Export • Share • Print" }
    end

    output = render(component)

    # Check border classes and their modifiers
    assert_includes(output, "border-b")
    assert_includes(output, "[.border-b]:pb-6")
    assert_includes(output, "border-t")
    assert_includes(output, "[.border-t]:pt-6")

    # Check content
    assert_includes(output, "Reports")
    assert_includes(output, "View your analytics")
    assert_includes(output, "Report content with tables and charts")
    assert_includes(output, "Export • Share • Print")
  end

  def test_card_grid_layout_with_action
    component = ShadcnPhlexcomponents::Card.new do |card|
      card.header do
        card.title { "Notifications" }
        card.description { "Manage your alerts" }
        card.action { "🔔 Settings" }
      end
      card.content { "Notification preferences and history" }
    end

    output = render(component)

    # Check grid layout classes for header with action
    assert_includes(output, "@container/card-header grid auto-rows-min")
    assert_includes(output, "has-data-[shadcn-phlexcomponents=card-action]:grid-cols-[1fr_auto]")
    assert_includes(output, "col-start-2 row-span-2 row-start-1 self-start justify-self-end")

    # Check content structure
    assert_includes(output, "Notifications")
    assert_includes(output, "Manage your alerts")
    assert_includes(output, "🔔 Settings")
    assert_includes(output, "Notification preferences and history")
  end

  def test_card_responsive_and_accessibility
    component = ShadcnPhlexcomponents::Card.new(
      role: "article",
      aria: { labelledby: "card-title", describedby: "card-desc" },
      class: "max-w-md mx-auto",
    ) do |card|
      card.header do
        card.title(id: "card-title") { "Article Title" }
        card.description(id: "card-desc") { "Article summary" }
      end
      card.content { "Article content goes here..." }
      card.footer do
        "Published: Dec 2024 • 5 min read"
      end
    end

    output = render(component)

    # Check accessibility attributes
    assert_includes(output, 'role="article"')
    assert_includes(output, 'aria-labelledby="card-title"')
    assert_includes(output, 'aria-describedby="card-desc"')
    assert_includes(output, 'id="card-title"')
    assert_includes(output, 'id="card-desc"')

    # Check responsive classes
    assert_includes(output, "max-w-md mx-auto")

    # Check structure
    assert_includes(output, "flex flex-col gap-6") # Card layout
    assert_includes(output, "Article Title")
    assert_includes(output, "Article summary")
    assert_includes(output, "Article content goes here...")
    assert_includes(output, "Published: Dec 2024 • 5 min read")
  end

  def test_card_with_complex_content
    component = ShadcnPhlexcomponents::Card.new(class: "w-96") do |card|
      card.header do
        card.title { "📈 Sales Dashboard" }
        card.description { "Track your performance metrics" }
        card.action do
          "📅 This Month"
        end
      end
      card.content(class: "space-y-4") do
        "💰 Revenue: $12,345"
      end
      card.footer(class: "justify-between") do
        "Updated 5 mins ago • 📊 View Details"
      end
    end

    output = render(component)

    # Check custom styling
    assert_includes(output, "w-96")
    assert_includes(output, "space-y-4")
    assert_includes(output, "justify-between")

    # Check emoji content
    assert_includes(output, "📈 Sales Dashboard")
    assert_includes(output, "📅 This Month")
    assert_includes(output, "💰 Revenue: $12,345")
    assert_includes(output, "📊 View Details")

    # Check base functionality still works
    assert_includes(output, "bg-card text-card-foreground")
    assert_includes(output, "rounded-xl border")
    assert_includes(output, "flex items-center px-6")
  end
end
