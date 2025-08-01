# frozen_string_literal: true

require "test_helper"

class TestPopover < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::Popover.new(open: false) { "Popover content" }
    output = render(component)

    assert_includes(output, "Popover content")
    assert_includes(output, "inline-flex max-w-fit")
    assert_includes(output, 'data-shadcn-phlexcomponents="popover"')
    assert_includes(output, 'data-controller="popover"')
    assert_includes(output, 'data-popover-is-open-value="false"')
    assert_match(%r{<div[^>]*>.*Popover content.*</div>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Popover.new(
      class: "custom-popover",
      id: "popover-id",
      data: { testid: "popover" },
    ) { "Custom content" }
    output = render(component)

    assert_includes(output, "custom-popover")
    assert_includes(output, 'id="popover-id"')
    assert_includes(output, 'data-testid="popover"')
    assert_includes(output, "inline-flex max-w-fit")
  end

  def test_it_should_handle_open_state
    component = ShadcnPhlexcomponents::Popover.new(open: true) { "Content" }
    output = render(component)

    assert_includes(output, 'data-popover-is-open-value="true"')
  end

  def test_it_should_generate_unique_aria_id
    popover1 = ShadcnPhlexcomponents::Popover.new do |popover|
      popover.trigger { "Trigger 1" }
      popover.content { "Content 1" }
    end
    output1 = render(popover1)

    popover2 = ShadcnPhlexcomponents::Popover.new do |popover|
      popover.trigger { "Trigger 2" }
      popover.content { "Content 2" }
    end
    output2 = render(popover2)

    # Extract aria-controls values to ensure they're different
    controls1 = output1[/aria-controls="([^"]*)"/, 1]
    controls2 = output2[/aria-controls="([^"]*)"/, 1]

    refute_nil(controls1)
    refute_nil(controls2)
    refute_equal(controls1, controls2)
  end

  def test_it_should_render_with_helper_methods
    component = ShadcnPhlexcomponents::Popover.new do |popover|
      popover.trigger(class: "custom-trigger") { "Open Popover" }
      popover.content(class: "custom-content") do
        "Popover content appears here"
      end
    end
    output = render(component)

    # Check trigger
    assert_includes(output, "Open Popover")
    assert_includes(output, "custom-trigger")
    assert_includes(output, 'role="button"')
    assert_includes(output, 'data-popover-target="trigger"')

    # Check content
    assert_includes(output, "custom-content")
    assert_includes(output, 'data-popover-target="content"')
    assert_includes(output, "Popover content appears here")
  end

  def test_it_should_render_complete_popover_structure
    component = ShadcnPhlexcomponents::Popover.new(
      open: false,
      class: "full-popover",
    ) do |popover|
      popover.trigger(class: "trigger-style") { "Complete Popover" }
      popover.content(class: "content-style", side: :top, align: :start) do
        "This is a complete popover with custom positioning"
      end
    end
    output = render(component)

    # Check main container
    assert_includes(output, "full-popover")
    assert_includes(output, 'data-controller="popover"')
    assert_includes(output, 'data-popover-is-open-value="false"')

    # Check trigger with styling
    assert_includes(output, "Complete Popover")
    assert_includes(output, "trigger-style")

    # Check content and positioning
    assert_includes(output, "content-style")
    assert_includes(output, 'data-side="top"')
    assert_includes(output, 'data-align="start"')

    # Check content text
    assert_includes(output, "This is a complete popover with custom positioning")

    # Check content container
    assert_includes(output, 'data-popover-target="contentContainer"')
    assert_includes(output, 'style="display: none;"')
  end
end

class TestPopoverTrigger < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::PopoverTrigger.new(
      aria_id: "test-popover",
    ) { "Trigger content" }
    output = render(component)

    assert_includes(output, "Trigger content")
    assert_includes(output, 'data-shadcn-phlexcomponents="popover-trigger"')
    assert_includes(output, 'role="button"')
    assert_includes(output, 'aria-controls="test-popover-content"')
    assert_includes(output, 'data-popover-target="trigger"')
    assert_includes(output, "click->popover#toggle")
    assert_match(%r{<div[^>]*>.*Trigger content.*</div>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::PopoverTrigger.new(
      aria_id: "custom-test",
      class: "custom-trigger",
      id: "trigger-id",
    ) { "Custom trigger" }
    output = render(component)

    assert_includes(output, "custom-trigger")
    assert_includes(output, 'id="trigger-id"')
    assert_includes(output, 'aria-controls="custom-test-content"')
  end

  def test_it_should_handle_as_child_mode
    component = ShadcnPhlexcomponents::PopoverTrigger.new(
      as_child: true,
      aria_id: "test",
    ) { "<button class=\"my-button\">Child Button</button>".html_safe }
    output = render(component)

    assert_includes(output, 'data-as-child="true"')
    assert_includes(output, "my-button")
    assert_includes(output, "Child Button")
    assert_includes(output, "click->popover#toggle")
  end

  def test_it_should_include_aria_attributes
    component = ShadcnPhlexcomponents::PopoverTrigger.new(aria_id: "accessibility-test")
    output = render(component)

    assert_includes(output, 'aria-haspopup="dialog"')
    # aria-expanded is handled dynamically by stimulus controller
    assert_includes(output, 'aria-controls="accessibility-test-content"')
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::PopoverTrigger.new(aria_id: "action-test")
    output = render(component)

    assert_includes(output, "click->popover#toggle")
  end
end

class TestPopoverContent < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::PopoverContent.new(
      aria_id: "test-content",
    ) { "Content body" }
    output = render(component)

    assert_includes(output, "Content body")
    assert_includes(output, 'data-shadcn-phlexcomponents="popover-content"')
    assert_includes(output, 'id="test-content-content"')
    assert_includes(output, 'role="dialog"')
    assert_includes(output, 'data-popover-target="content"')
    assert_includes(output, 'tabindex="-1"')
  end

  def test_it_should_handle_positioning_attributes
    component = ShadcnPhlexcomponents::PopoverContent.new(
      aria_id: "position-test",
      side: :top,
      align: :end,
    ) { "Positioned content" }
    output = render(component)

    assert_includes(output, 'data-side="top"')
    assert_includes(output, 'data-align="end"')
  end

  def test_it_should_use_default_positioning
    component = ShadcnPhlexcomponents::PopoverContent.new(
      aria_id: "default-test",
    ) { "Default positioned content" }
    output = render(component)

    assert_includes(output, 'data-side="bottom"')
    assert_includes(output, 'data-align="center"')
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::PopoverContent.new(aria_id: "action-test")
    output = render(component)

    assert_includes(output, "popover:click:outside->popover#clickOutside")
  end

  def test_it_should_use_content_container
    component = ShadcnPhlexcomponents::PopoverContent.new(aria_id: "container-test")
    output = render(component)

    # Check that content is wrapped in container
    assert_includes(output, 'data-popover-target="contentContainer"')
    assert_includes(output, 'style="display: none;"')
    assert_includes(output, "fixed top-0 left-0 w-max z-50")
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::PopoverContent.new(aria_id: "style-test")
    output = render(component)

    assert_includes(output, "bg-popover text-popover-foreground")
    assert_includes(output, "data-[state=open]:animate-in data-[state=closed]:animate-out")
    assert_includes(output, "data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0")
    assert_includes(output, "z-50")
    assert_includes(output, "w-72")
    assert_includes(output, "rounded-md")
    assert_includes(output, "border")
    assert_includes(output, "p-4")
    assert_includes(output, "shadow-md")
    assert_includes(output, "outline-hidden")
  end
end

class TestPopoverContentContainer < ComponentTest
  def test_it_should_render_container
    component = ShadcnPhlexcomponents::PopoverContentContainer.new { "Container content" }
    output = render(component)

    assert_includes(output, "Container content")
    assert_includes(output, 'data-shadcn-phlexcomponents="popover-content-container"')
    assert_includes(output, 'data-popover-target="contentContainer"')
    assert_includes(output, 'style="display: none;"')
    assert_includes(output, "fixed top-0 left-0 w-max z-50")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::PopoverContentContainer.new(
      class: "custom-container",
      id: "container-id",
    ) { "Custom container" }
    output = render(component)

    assert_includes(output, "custom-container")
    assert_includes(output, 'id="container-id"')
  end
end

class TestPopoverWithCustomConfiguration < ComponentTest
  def test_popover_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.popover = {
      root: { base: "custom-popover-base" },
      content: { base: "custom-content-base" },
      content_container: { base: "custom-content-container-base" },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload classes
    popover_classes = [
      "PopoverContentContainer", "PopoverContent", "PopoverTrigger", "Popover",
    ]

    popover_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/popover.rb", __dir__))

    # Test components with custom configuration
    popover = ShadcnPhlexcomponents::Popover.new { "Test" }
    assert_includes(render(popover), "custom-popover-base")

    content = ShadcnPhlexcomponents::PopoverContent.new(aria_id: "test") { "Content" }
    assert_includes(render(content), "custom-content-base")

    container = ShadcnPhlexcomponents::PopoverContentContainer.new { "Container" }
    assert_includes(render(container), "custom-content-container-base")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    popover_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/popover.rb", __dir__))
  end
end

class TestPopoverIntegration < ComponentTest
  def test_complete_popover_workflow
    component = ShadcnPhlexcomponents::Popover.new(
      open: false,
      class: "user-settings-popover",
      data: { controller: "popover analytics", analytics_category: "user-settings" },
    ) do |popover|
      popover.trigger(class: "settings-trigger") { "⚙️ Settings" }
      popover.content(class: "settings-content", side: :right, align: :start) do
        "🔧 Account Settings\n👤 Profile\n🔒 Privacy\n🚪 Logout"
      end
    end

    output = render(component)

    # Check main structure
    assert_includes(output, "user-settings-popover")
    # Controller merging may include spaces
    assert_match(/data-controller="[^"]*popover[^"]*analytics[^"]*"/, output)
    assert_includes(output, 'data-analytics-category="user-settings"')

    # Check trigger with emoji
    assert_includes(output, "⚙️ Settings")
    assert_includes(output, "settings-trigger")

    # Check content positioning
    assert_includes(output, "settings-content")
    assert_includes(output, 'data-side="right"')
    assert_includes(output, 'data-align="start"')

    # Check content with emojis
    assert_includes(output, "🔧 Account Settings")
    assert_includes(output, "👤 Profile")
    assert_includes(output, "🔒 Privacy")
    assert_includes(output, "🚪 Logout")

    # Check popover actions
    assert_includes(output, "click->popover#toggle")
    assert_includes(output, "popover:click:outside->popover#clickOutside")
  end

  def test_popover_accessibility_features
    component = ShadcnPhlexcomponents::Popover.new(
      aria: { label: "User menu popover", describedby: "menu-help" },
    ) do |popover|
      popover.trigger(aria: { labelledby: "menu-label" }) { "Accessible trigger" }
      popover.content do
        "This popover follows accessibility guidelines"
      end
    end

    output = render(component)

    # Check accessibility attributes
    assert_includes(output, 'aria-label="User menu popover"')
    assert_includes(output, 'aria-describedby="menu-help"')
    assert_includes(output, 'aria-labelledby="menu-label"')

    # Check ARIA roles and relationships
    assert_includes(output, 'role="button"') # trigger
    assert_includes(output, 'role="dialog"') # content
    assert_includes(output, 'aria-haspopup="dialog"')
    assert_match(/aria-controls="[^"]*-content"/, output)
    assert_includes(output, 'tabindex="-1"') # content
  end

  def test_popover_stimulus_integration
    component = ShadcnPhlexcomponents::Popover.new(
      data: {
        controller: "popover custom-tooltip",
        custom_tooltip_delay_value: "300",
      },
    ) do |popover|
      popover.trigger(
        data: { action: "mouseover->custom-tooltip#show" },
      ) { "Stimulus trigger" }

      popover.content do
        "Custom tooltip content"
      end
    end

    output = render(component)

    # Check multiple controllers
    assert_match(/data-controller="[^"]*popover[^"]*custom-tooltip[^"]*"/, output)
    assert_includes(output, 'data-custom-tooltip-delay-value="300"')

    # Check custom actions
    assert_includes(output, "custom-tooltip#show")

    # Check default popover actions still work
    assert_includes(output, "click->popover#toggle")
    assert_includes(output, "popover:click:outside->popover#clickOutside")
  end

  def test_popover_positioning_variations
    # Test different positioning combinations
    positions = [
      { side: :top, align: :start },
      { side: :bottom, align: :center },
      { side: :left, align: :end },
      { side: :right, align: :center },
    ]

    positions.each do |position|
      component = ShadcnPhlexcomponents::Popover.new do |popover|
        popover.trigger { "Trigger" }
        popover.content(**position) { "Content" }
      end

      output = render(component)

      assert_includes(output, "data-side=\"#{position[:side]}\"")
      assert_includes(output, "data-align=\"#{position[:align]}\"")
    end
  end

  def test_popover_as_child_integration
    component = ShadcnPhlexcomponents::Popover.new do |popover|
      popover.trigger(as_child: true) do
        "<button class=\"custom-btn\">Custom Button</button>".html_safe
      end
      popover.content do
        "Popover content"
      end
    end

    output = render(component)

    # Check as_child functionality
    assert_includes(output, 'data-as-child="true"')
    assert_includes(output, "custom-btn")
    assert_includes(output, "Custom Button")
    assert_includes(output, "click->popover#toggle")
    assert_includes(output, 'aria-haspopup="dialog"')
  end

  def test_popover_complex_content
    component = ShadcnPhlexcomponents::Popover.new do |popover|
      popover.trigger { "📊 Dashboard Menu" }
      popover.content(class: "dashboard-popover") do
        "📈 Analytics\n📋 Reports\n👥 Users\n⚙️ Settings\n❓ Help"
      end
    end

    output = render(component)

    # Check trigger
    assert_includes(output, "📊 Dashboard Menu")

    # Check complex content with multiple emojis
    assert_includes(output, "dashboard-popover")
    assert_includes(output, "📈 Analytics")
    assert_includes(output, "📋 Reports")
    assert_includes(output, "👥 Users")
    assert_includes(output, "⚙️ Settings")
    assert_includes(output, "❓ Help")

    # Check popover structure
    assert_includes(output, 'role="dialog"')
    assert_includes(output, "w-72")
    assert_includes(output, "rounded-md")
    assert_includes(output, "border")
    assert_includes(output, "p-4")
  end

  def test_popover_form_integration
    component = ShadcnPhlexcomponents::Popover.new do |popover|
      popover.trigger { "💬 Quick Contact" }
      popover.content(class: "contact-form") do
        "📧 Email: contact@example.com\n📞 Phone: (555) 123-4567\n💬 Chat available 9-5 EST"
      end
    end

    output = render(component)

    # Check contact form structure
    assert_includes(output, "💬 Quick Contact")
    assert_includes(output, "contact-form")
    assert_includes(output, "📧 Email: contact@example.com")
    assert_includes(output, "📞 Phone: (555) 123-4567")
    assert_includes(output, "💬 Chat available 9-5 EST")

    # Check dialog role for form content
    assert_includes(output, 'role="dialog"')
  end
end
