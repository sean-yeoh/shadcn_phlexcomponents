# frozen_string_literal: true

require "test_helper"

class TestCollapsible < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::Collapsible.new { "Collapsible content" }
    output = render(component)

    assert_includes(output, "Collapsible content")
    assert_includes(output, 'data-shadcn-phlexcomponents="collapsible"')
    assert_includes(output, 'data-controller="collapsible"')
    assert_includes(output, 'data-collapsible-is-open-value="false"')
    assert_match(%r{<div[^>]*>Collapsible content</div>}, output)
  end

  def test_it_should_render_closed_by_default
    component = ShadcnPhlexcomponents::Collapsible.new
    output = render(component)

    assert_includes(output, 'data-collapsible-is-open-value="false"')
    assert_includes(output, 'data-controller="collapsible"')
  end

  def test_it_should_render_open_when_specified
    component = ShadcnPhlexcomponents::Collapsible.new(open: true)
    output = render(component)

    assert_includes(output, 'data-collapsible-is-open-value="true"')
    assert_includes(output, 'data-controller="collapsible"')
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Collapsible.new(
      class: "collapsible-class",
      id: "collapsible-id",
      data: { testid: "collapsible", custom: "value" },
    )
    output = render(component)

    assert_includes(output, "collapsible-class")
    assert_includes(output, 'id="collapsible-id"')
    assert_includes(output, 'data-testid="collapsible"')
    assert_includes(output, 'data-custom="value"')
    assert_includes(output, 'data-controller="collapsible"')
  end

  def test_it_should_generate_unique_aria_id
    component1 = ShadcnPhlexcomponents::Collapsible.new(open: true) do |collapsible|
      collapsible.trigger { "Trigger 1" }
      collapsible.content { "Content 1" }
    end
    output1 = render(component1)

    component2 = ShadcnPhlexcomponents::Collapsible.new do |collapsible|
      collapsible.trigger { "Trigger 2" }
      collapsible.content { "Content 2" }
    end
    output2 = render(component2)

    # Extract aria-controls values to ensure they're different
    controls1 = output1[/aria-controls="([^"]*)"/, 1]
    controls2 = output2[/aria-controls="([^"]*)"/, 1]

    refute_nil(controls1)
    refute_nil(controls2)
    refute_equal(controls1, controls2)
  end

  def test_it_should_render_with_trigger_and_content
    component = ShadcnPhlexcomponents::Collapsible.new do |collapsible|
      collapsible.trigger { "Click to toggle" }
      collapsible.content { "Hidden content here" }
    end
    output = render(component)

    # Check trigger content
    assert_includes(output, "Click to toggle")
    assert_includes(output, 'role="button"')
    assert_includes(output, 'aria-expanded="false"')
    assert_includes(output, 'data-state="closed"')
    assert_includes(output, 'data-action="click->collapsible#toggle"')
    assert_includes(output, 'data-collapsible-target="trigger"')

    # Check content
    assert_includes(output, "Hidden content here")
    assert_includes(output, 'style="display: none;"')
    assert_includes(output, 'data-collapsible-target="content"')

    # Check aria relationship
    assert_match(/aria-controls="collapsible-[a-f0-9]+-content"/, output)
    assert_match(/id="collapsible-[a-f0-9]+-content"/, output)
  end

  def test_it_should_handle_open_state_properly
    component = ShadcnPhlexcomponents::Collapsible.new(open: true) do |collapsible|
      collapsible.trigger { "Toggle me" }
      collapsible.content { "Visible content" }
    end
    output = render(component)

    # When open, the data value should be true
    assert_includes(output, 'data-collapsible-is-open-value="true"')

    # Content should still have display: none initially (controlled by JS)
    assert_includes(output, 'style="display: none;"')

    # Trigger should still show closed state initially (controlled by JS)
    assert_includes(output, 'aria-expanded="false"')
    assert_includes(output, 'data-state="closed"')
  end

  def test_it_should_render_complete_collapsible_structure
    component = ShadcnPhlexcomponents::Collapsible.new(
      open: false,
      class: "faq-item",
      data: { category: "help" },
    ) do |collapsible|
      collapsible.trigger(class: "faq-trigger") { "What is this?" }
      collapsible.content(class: "faq-content") { "This is the answer to your question." }
    end
    output = render(component)

    # Check main container
    assert_includes(output, "faq-item")
    assert_includes(output, 'data-category="help"')
    assert_includes(output, 'data-controller="collapsible"')
    assert_includes(output, 'data-collapsible-is-open-value="false"')

    # Check trigger
    assert_includes(output, "What is this?")
    assert_includes(output, "faq-trigger")
    assert_includes(output, 'role="button"')
    assert_includes(output, 'data-collapsible-target="trigger"')

    # Check content
    assert_includes(output, "This is the answer to your question.")
    assert_includes(output, "faq-content")
    assert_includes(output, 'data-collapsible-target="content"')
    assert_includes(output, 'style="display: none;"')
  end
end

class TestCollapsibleTrigger < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::CollapsibleTrigger.new(aria_id: "test-id") { "Trigger content" }
    output = render(component)

    assert_includes(output, "Trigger content")
    assert_includes(output, 'data-shadcn-phlexcomponents="collapsible-trigger"')
    assert_includes(output, 'role="button"')
    assert_includes(output, 'aria-expanded="false"')
    assert_includes(output, 'aria-controls="test-id-content"')
    assert_includes(output, 'data-state="closed"')
    assert_includes(output, 'data-action="click->collapsible#toggle"')
    assert_includes(output, 'data-collapsible-target="trigger"')
    assert_match(%r{<div[^>]*>.*Trigger content.*</div>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::CollapsibleTrigger.new(
      aria_id: "custom-id",
      class: "trigger-class",
      id: "trigger-id",
      data: { testid: "trigger" },
    ) { "Custom trigger" }
    output = render(component)

    assert_includes(output, "trigger-class")
    assert_includes(output, 'id="trigger-id"')
    assert_includes(output, 'data-testid="trigger"')
    assert_includes(output, 'aria-controls="custom-id-content"')
    assert_includes(output, "Custom trigger")
  end

  def test_it_should_handle_as_child_functionality
    component = ShadcnPhlexcomponents::CollapsibleTrigger.new(
      as_child: true,
      aria_id: "child-test",
    ) do
      "<button class='custom-button'>Custom Button</button>".html_safe
    end
    output = render(component)

    # Should render as button element with merged attributes
    # Note: role="button" is removed when merging with actual button element
    assert_includes(output, 'aria-expanded="false"')
    assert_includes(output, 'aria-controls="child-test-content"')
    assert_includes(output, 'data-action="click->collapsible#toggle"')
    assert_includes(output, 'data-collapsible-target="trigger"')
    assert_includes(output, "custom-button")
    assert_includes(output, "Custom Button")
    assert_match(%r{<button[^>]*>.*Custom Button.*</button>}m, output)
  end

  def test_it_should_handle_nil_aria_id
    component = ShadcnPhlexcomponents::CollapsibleTrigger.new(aria_id: nil) { "No ID trigger" }
    output = render(component)

    assert_includes(output, "No ID trigger")
    assert_includes(output, 'aria-controls="-content"')
    assert_includes(output, 'role="button"')
  end

  def test_it_should_render_default_closed_state
    component = ShadcnPhlexcomponents::CollapsibleTrigger.new(aria_id: "state-test")
    output = render(component)

    assert_includes(output, 'aria-expanded="false"')
    assert_includes(output, 'data-state="closed"')
    assert_includes(output, 'data-action="click->collapsible#toggle"')
  end
end

class TestCollapsibleContent < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::CollapsibleContent.new(aria_id: "test-content") { "Content here" }
    output = render(component)

    assert_includes(output, "Content here")
    assert_includes(output, 'data-shadcn-phlexcomponents="collapsible-content"')
    assert_includes(output, 'id="test-content-content"')
    assert_includes(output, 'data-collapsible-target="content"')
    assert_includes(output, 'style="display: none;"')
    assert_match(%r{<div[^>]*style="display: none;"[^>]*>Content here</div>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::CollapsibleContent.new(
      aria_id: "custom-content",
      class: "content-class",
      data: { testid: "content" },
    ) { "Custom content" }
    output = render(component)

    assert_includes(output, "content-class")
    assert_includes(output, 'data-testid="content"')
    assert_includes(output, 'id="custom-content-content"')
    assert_includes(output, "Custom content")
    assert_includes(output, 'style="display: none;"')
  end

  def test_it_should_handle_nil_aria_id
    component = ShadcnPhlexcomponents::CollapsibleContent.new(aria_id: nil) { "No ID content" }
    output = render(component)

    assert_includes(output, "No ID content")
    assert_includes(output, 'id="-content"')
    assert_includes(output, 'data-collapsible-target="content"')
  end

  def test_it_should_always_render_hidden_initially
    component = ShadcnPhlexcomponents::CollapsibleContent.new(aria_id: "hidden-test") { "Hidden initially" }
    output = render(component)

    # Content should always start hidden (JavaScript controls visibility)
    assert_includes(output, 'style="display: none;"')
    assert_includes(output, "Hidden initially")
  end
end

class TestCollapsibleIntegration < ComponentTest
  def test_complete_collapsible_functionality
    component = ShadcnPhlexcomponents::Collapsible.new(
      open: false,
      class: "accordion-item border rounded-lg",
      data: { controller: "collapsible analytics", analytics_id: "faq-1" },
    ) do |collapsible|
      collapsible.trigger(
        class: "w-full text-left p-4 font-medium",
        data: { action: "click->analytics#track" },
      ) { "🤔 How does this work?" }

      collapsible.content(
        class: "px-4 pb-4 text-gray-600",
      ) { "This component uses Stimulus to handle the show/hide functionality." }
    end

    output = render(component)

    # Check main collapsible container
    assert_includes(output, "accordion-item border rounded-lg")
    # Check multiple Stimulus controllers (may include duplicates due to merging)
    assert_match(/data-controller="[^"]*analytics/, output)
    assert_includes(output, 'data-analytics-id="faq-1"')
    assert_includes(output, 'data-collapsible-is-open-value="false"')

    # Check trigger styling and functionality
    assert_includes(output, "🤔 How does this work?")
    assert_includes(output, "w-full text-left p-4 font-medium")
    assert_match(/click->analytics#track/, output)
    assert_includes(output, 'role="button"')
    assert_includes(output, 'aria-expanded="false"')

    # Check content styling
    assert_includes(output, "This component uses Stimulus to handle the show/hide functionality.")
    assert_includes(output, "px-4 pb-4 text-gray-600")
    assert_includes(output, 'style="display: none;"')

    # Check ARIA relationship
    assert_match(/aria-controls="collapsible-[a-f0-9]+-content"/, output)
    assert_match(/id="collapsible-[a-f0-9]+-content"/, output)
  end

  def test_collapsible_with_as_child_trigger
    component = ShadcnPhlexcomponents::Collapsible.new do |collapsible|
      collapsible.trigger(as_child: true) do
        "<button class='btn btn-primary' type='button'>Custom Toggle Button</button>".html_safe
      end
      collapsible.content { "Content controlled by custom button" }
    end

    output = render(component)

    # Check that as_child functionality works
    assert_includes(output, "btn btn-primary")
    assert_includes(output, "Custom Toggle Button")
    # NOTE: role="button" is removed when merging with actual button element
    assert_includes(output, 'data-action="click->collapsible#toggle"')
    assert_includes(output, 'data-collapsible-target="trigger"')

    # Should still have button element
    assert_match(%r{<button[^>]*>.*Custom Toggle Button.*</button>}m, output)

    # Content should still work normally
    assert_includes(output, "Content controlled by custom button")
    assert_includes(output, 'data-collapsible-target="content"')
  end

  def test_collapsible_accessibility_features
    component = ShadcnPhlexcomponents::Collapsible.new(
      open: true,
      aria: { label: "FAQ Section" },
      role: "region",
    ) do |collapsible|
      collapsible.trigger(
        aria: { describedby: "faq-help" },
        tabindex: 0,
      ) { "Accessible Trigger" }

      collapsible.content(
        aria: { live: "polite" },
        role: "region",
      ) { "Accessible content with live region" }
    end

    output = render(component)

    # Check main container accessibility
    assert_includes(output, 'aria-label="FAQ Section"')
    assert_includes(output, 'role="region"')

    # Check trigger accessibility
    assert_includes(output, 'aria-describedby="faq-help"')
    assert_includes(output, 'tabindex="0"')
    assert_includes(output, 'aria-expanded="false"')
    assert_includes(output, 'role="button"')

    # Check content accessibility
    assert_includes(output, 'aria-live="polite"')
    assert_includes(output, 'role="region"')

    # Check ARIA controls relationship
    assert_match(/aria-controls="collapsible-[a-f0-9]+-content"/, output)
    assert_match(/id="collapsible-[a-f0-9]+-content"/, output)
  end

  def test_collapsible_with_nested_content
    component = ShadcnPhlexcomponents::Collapsible.new do |collapsible|
      collapsible.trigger(class: "section-header") do
        "📋 Advanced Settings"
      end

      collapsible.content(class: "section-content") do
        "
        <div class='setting-group'>
          <h4>Database Configuration</h4>
          <p>Configure your database connection settings here.</p>
          <div class='form-controls'>
            <input type='text' placeholder='Host' />
            <input type='text' placeholder='Port' />
          </div>
        </div>
        "
      end
    end

    output = render(component)

    # Check trigger
    assert_includes(output, "📋 Advanced Settings")
    assert_includes(output, "section-header")

    # Check nested content structure is preserved (HTML escaped)
    assert_includes(output, "section-content")
    assert_includes(output, "Database Configuration")
    assert_includes(output, "setting-group")
    assert_includes(output, "form-controls")
    assert_includes(output, "placeholder=&#39;Host&#39;")
    assert_includes(output, "placeholder=&#39;Port&#39;")

    # Check functionality
    assert_includes(output, 'data-controller="collapsible"')
    assert_includes(output, 'data-collapsible-target="trigger"')
    assert_includes(output, 'data-collapsible-target="content"')
  end

  def test_multiple_collapsibles_independence
    # Test that multiple collapsibles have independent IDs and controls
    collapsible1 = ShadcnPhlexcomponents::Collapsible.new do |c|
      c.trigger { "First Trigger" }
      c.content { "First Content" }
    end

    collapsible2 = ShadcnPhlexcomponents::Collapsible.new(open: true) do |c|
      c.trigger { "Second Trigger" }
      c.content { "Second Content" }
    end

    output1 = render(collapsible1)
    output2 = render(collapsible2)

    # Extract the generated IDs
    id1 = output1[/id="(collapsible-[a-f0-9]+-content)"/, 1]
    id2 = output2[/id="(collapsible-[a-f0-9]+-content)"/, 1]

    # IDs should be different
    refute_equal(id1, id2)

    # Each should control its own content
    assert_includes(output1, "aria-controls=\"#{id1}\"")
    assert_includes(output2, "aria-controls=\"#{id2}\"")

    # Check different states
    assert_includes(output1, 'data-collapsible-is-open-value="false"')
    assert_includes(output2, 'data-collapsible-is-open-value="true"')
  end

  def test_collapsible_stimulus_integration
    component = ShadcnPhlexcomponents::Collapsible.new(
      open: false,
      data: {
        controller: "collapsible custom-controller",
        custom_controller_setting_value: "test",
      },
    ) do |collapsible|
      collapsible.trigger(
        data: {
          action: "click->custom-controller#beforeToggle click->collapsible#toggle",
        },
      ) { "Multi-controller Trigger" }

      collapsible.content { "Multi-controller Content" }
    end

    output = render(component)

    # Check multiple Stimulus controllers
    assert_match(/data-controller="[^"]*custom-controller/, output)
    assert_includes(output, 'data-custom-controller-setting-value="test"')

    # Check multiple actions on trigger
    assert_match(/click->custom-controller#beforeToggle/, output)
    assert_match(/click->collapsible#toggle/, output)

    # Check targets are still set
    assert_includes(output, 'data-collapsible-target="trigger"')
    assert_includes(output, 'data-collapsible-target="content"')

    # Check collapsible-specific data
    assert_includes(output, 'data-collapsible-is-open-value="false"')
  end

  def test_collapsible_edge_cases
    # Test with empty content
    empty_collapsible = ShadcnPhlexcomponents::Collapsible.new do |c|
      c.trigger { "Empty Content Trigger" }
      c.content { "" }
    end
    empty_output = render(empty_collapsible)

    assert_includes(empty_output, "Empty Content Trigger")
    assert_includes(empty_output, 'data-collapsible-target="content"')
    assert_includes(empty_output, 'style="display: none;"')

    # Test with only trigger (no content)
    trigger_only = ShadcnPhlexcomponents::Collapsible.new do |c|
      c.trigger { "Only Trigger" }
    end
    trigger_output = render(trigger_only)

    assert_includes(trigger_output, "Only Trigger")
    assert_includes(trigger_output, 'data-collapsible-target="trigger"')
    # Should not have content target
    refute_includes(trigger_output, 'data-collapsible-target="content"')

    # Test with only content (no trigger)
    content_only = ShadcnPhlexcomponents::Collapsible.new do |c|
      c.content { "Only Content" }
    end
    content_output = render(content_only)

    assert_includes(content_output, "Only Content")
    assert_includes(content_output, 'data-collapsible-target="content"')
    # Should not have trigger target
    refute_includes(content_output, 'data-collapsible-target="trigger"')
  end
end
