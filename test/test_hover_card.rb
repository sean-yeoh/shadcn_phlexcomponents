# frozen_string_literal: true

require "test_helper"

class TestHoverCard < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::HoverCard.new(open: false) { "Hover card content" }
    output = render(component)

    assert_includes(output, "Hover card content")
    assert_includes(output, "inline-flex max-w-fit")
    assert_includes(output, 'data-shadcn-phlexcomponents="hover-card"')
    assert_includes(output, 'data-controller="hover-card"')
    assert_includes(output, 'data-hover-card-is-open-value="false"')
    assert_match(%r{<div[^>]*>.*Hover card content.*</div>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::HoverCard.new(
      class: "custom-hover-card",
      id: "hover-card-id",
      data: { testid: "hover-card" },
    ) { "Custom content" }
    output = render(component)

    assert_includes(output, "custom-hover-card")
    assert_includes(output, 'id="hover-card-id"')
    assert_includes(output, 'data-testid="hover-card"')
    assert_includes(output, "inline-flex max-w-fit")
  end

  def test_it_should_handle_open_state
    component = ShadcnPhlexcomponents::HoverCard.new(open: true) { "Content" }
    output = render(component)

    assert_includes(output, 'data-hover-card-is-open-value="true"')
  end

  def test_it_should_render_with_helper_methods
    component = ShadcnPhlexcomponents::HoverCard.new do |hover_card|
      hover_card.trigger(class: "custom-trigger") { "Hover me" }
      hover_card.content(class: "custom-content") do
        "Hover card content appears here"
      end
    end
    output = render(component)

    # Check trigger
    assert_includes(output, "Hover me")
    assert_includes(output, "custom-trigger")
    assert_includes(output, 'role="button"')
    assert_includes(output, 'data-hover-card-target="trigger"')

    # Check content
    assert_includes(output, "custom-content")
    assert_includes(output, 'data-hover-card-target="content"')
    assert_includes(output, "Hover card content appears here")
  end

  def test_it_should_render_complete_hover_card_structure
    component = ShadcnPhlexcomponents::HoverCard.new(
      open: false,
      class: "full-hover-card",
    ) do |hover_card|
      hover_card.trigger(class: "trigger-style") { "Complete Hover Card" }
      hover_card.content(class: "content-style", side: :top, align: :start) do
        "This is a complete hover card with custom positioning"
      end
    end
    output = render(component)

    # Check main container
    assert_includes(output, "full-hover-card")
    assert_includes(output, 'data-controller="hover-card"')
    assert_includes(output, 'data-hover-card-is-open-value="false"')

    # Check trigger with styling
    assert_includes(output, "Complete Hover Card")
    assert_includes(output, "trigger-style")

    # Check content and positioning
    assert_includes(output, "content-style")
    assert_includes(output, 'data-side="top"')
    assert_includes(output, 'data-align="start"')

    # Check content text
    assert_includes(output, "This is a complete hover card with custom positioning")

    # Check content container
    assert_includes(output, 'data-hover-card-target="contentContainer"')
    assert_includes(output, 'style="display: none;"')
  end
end

class TestHoverCardTrigger < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::HoverCardTrigger.new { "Trigger content" }
    output = render(component)

    assert_includes(output, "Trigger content")
    assert_includes(output, 'data-shadcn-phlexcomponents="hover-card-trigger"')
    assert_includes(output, 'role="button"')
    assert_includes(output, 'data-hover-card-target="trigger"')
    assert_match(%r{<div[^>]*>.*Trigger content.*</div>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::HoverCardTrigger.new(
      class: "custom-trigger",
      id: "trigger-id",
    ) { "Custom trigger" }
    output = render(component)

    assert_includes(output, "custom-trigger")
    assert_includes(output, 'id="trigger-id"')
  end

  def test_it_should_handle_as_child_mode
    component = ShadcnPhlexcomponents::HoverCardTrigger.new(as_child: true) do
      "<button class=\"my-button\">Child Button</button>".html_safe
    end
    output = render(component)

    assert_includes(output, 'data-as-child="true"')
    assert_includes(output, "my-button")
    assert_includes(output, "Child Button")
    assert_includes(output, "focus->hover-card#open")
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::HoverCardTrigger.new
    output = render(component)

    assert_includes(output, "focus->hover-card#open")
    assert_includes(output, "blur->hover-card#close")
    assert_includes(output, "click->hover-card#open")
  end
end

class TestHoverCardContent < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::HoverCardContent.new { "Content body" }
    output = render(component)

    assert_includes(output, "Content body")
    assert_includes(output, 'data-shadcn-phlexcomponents="hover-card-content"')
    assert_includes(output, 'data-hover-card-target="content"')
    assert_includes(output, 'tabindex="-1"')
  end

  def test_it_should_handle_positioning_attributes
    component = ShadcnPhlexcomponents::HoverCardContent.new(
      side: :top,
      align: :end,
    ) { "Positioned content" }
    output = render(component)

    assert_includes(output, 'data-side="top"')
    assert_includes(output, 'data-align="end"')
  end

  def test_it_should_use_default_positioning
    component = ShadcnPhlexcomponents::HoverCardContent.new { "Default positioned content" }
    output = render(component)

    assert_includes(output, 'data-side="bottom"')
    assert_includes(output, 'data-align="center"')
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::HoverCardContent.new
    output = render(component)

    assert_includes(output, "mouseover->hover-card#open")
    assert_includes(output, "mouseout->hover-card#close")
  end

  def test_it_should_use_content_container
    component = ShadcnPhlexcomponents::HoverCardContent.new
    output = render(component)

    # Check that content is wrapped in container
    assert_includes(output, 'data-hover-card-target="contentContainer"')
    assert_includes(output, 'style="display: none;"')
    assert_includes(output, "fixed top-0 left-0 w-max z-50")
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::HoverCardContent.new
    output = render(component)

    assert_includes(output, "bg-popover text-popover-foreground")
    assert_includes(output, "data-[state=open]:animate-in data-[state=closed]:animate-out")
    assert_includes(output, "data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0")
    assert_includes(output, "z-50")
    assert_includes(output, "w-64")
    assert_includes(output, "rounded-md border p-4 shadow-md outline-hidden")
  end
end

class TestHoverCardContentContainer < ComponentTest
  def test_it_should_render_container
    component = ShadcnPhlexcomponents::HoverCardContentContainer.new { "Container content" }
    output = render(component)

    assert_includes(output, "Container content")
    assert_includes(output, 'data-shadcn-phlexcomponents="hover-card-content-container"')
    assert_includes(output, 'data-hover-card-target="contentContainer"')
    assert_includes(output, 'style="display: none;"')
    assert_includes(output, "fixed top-0 left-0 w-max z-50")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::HoverCardContentContainer.new(
      class: "custom-container",
      id: "container-id",
    ) { "Custom container" }
    output = render(component)

    assert_includes(output, "custom-container")
    assert_includes(output, 'id="container-id"')
  end
end

class TestHoverCardWithCustomConfiguration < ComponentTest
  def test_hover_card_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.hover_card = {
      root: { base: "custom-hover-card-base" },
      content: { base: "custom-content-base" },
      content_container: { base: "custom-content-container-base" },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload classes
    hover_card_classes = [
      "HoverCardContentContainer", "HoverCardContent", "HoverCardTrigger", "HoverCard",
    ]

    hover_card_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/hover_card.rb", __dir__))

    # Test components with custom configuration
    hover_card = ShadcnPhlexcomponents::HoverCard.new { "Test" }
    assert_includes(render(hover_card), "custom-hover-card-base")

    content = ShadcnPhlexcomponents::HoverCardContent.new { "Content" }
    assert_includes(render(content), "custom-content-base")

    container = ShadcnPhlexcomponents::HoverCardContentContainer.new { "Container" }
    assert_includes(render(container), "custom-content-container-base")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    hover_card_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/hover_card.rb", __dir__))
  end
end

class TestHoverCardIntegration < ComponentTest
  def test_complete_hover_card_workflow
    component = ShadcnPhlexcomponents::HoverCard.new(
      open: false,
      class: "user-profile-card",
      data: { controller: "hover-card analytics", analytics_category: "user-profile" },
    ) do |hover_card|
      hover_card.trigger(class: "profile-trigger") { "👤 User Profile" }
      hover_card.content(class: "profile-content", side: :right, align: :start) do
        "📧 john@example.com\n📞 +1 (555) 123-4567\n🏢 Software Engineer"
      end
    end

    output = render(component)

    # Check main structure
    assert_includes(output, "user-profile-card")
    # Controller merging may include spaces
    assert_match(/data-controller="[^"]*hover-card[^"]*analytics[^"]*"/, output)
    assert_includes(output, 'data-analytics-category="user-profile"')

    # Check trigger with emoji
    assert_includes(output, "👤 User Profile")
    assert_includes(output, "profile-trigger")

    # Check content positioning
    assert_includes(output, "profile-content")
    assert_includes(output, 'data-side="right"')
    assert_includes(output, 'data-align="start"')

    # Check content with emojis
    assert_includes(output, "📧 john@example.com")
    assert_includes(output, "📞 +1 (555) 123-4567")
    assert_includes(output, "🏢 Software Engineer")

    # Check hover actions
    assert_includes(output, "focus->hover-card#open")
    assert_includes(output, "mouseover->hover-card#open")
    assert_includes(output, "mouseout->hover-card#close")
  end

  def test_hover_card_accessibility_features
    component = ShadcnPhlexcomponents::HoverCard.new(
      aria: { label: "User profile card", describedby: "profile-help" },
    ) do |hover_card|
      hover_card.trigger(aria: { labelledby: "profile-label" }) { "Accessible trigger" }
      hover_card.content do
        "This hover card follows accessibility guidelines"
      end
    end

    output = render(component)

    # Check accessibility attributes
    assert_includes(output, 'aria-label="User profile card"')
    assert_includes(output, 'aria-describedby="profile-help"')
    assert_includes(output, 'aria-labelledby="profile-label"')

    # Check ARIA roles
    assert_includes(output, 'role="button"') # trigger
    assert_includes(output, 'tabindex="-1"') # content
  end

  def test_hover_card_stimulus_integration
    component = ShadcnPhlexcomponents::HoverCard.new(
      data: {
        controller: "hover-card custom-tooltip",
        custom_tooltip_delay_value: "500",
      },
    ) do |hover_card|
      hover_card.trigger(
        data: { action: "mouseover->custom-tooltip#beforeShow" },
      ) { "Stimulus trigger" }

      hover_card.content do
        "Custom tooltip content"
      end
    end

    output = render(component)

    # Check multiple controllers
    assert_match(/data-controller="[^"]*hover-card[^"]*custom-tooltip[^"]*"/, output)
    assert_includes(output, 'data-custom-tooltip-delay-value="500"')

    # Check custom actions
    assert_match(/mouseover->custom-tooltip#beforeShow/, output)

    # Check default hover-card actions still work
    assert_match(/focus->hover-card#open/, output)
    assert_match(/mouseover->hover-card#open/, output)
    assert_match(/mouseout->hover-card#close/, output)
  end
end
