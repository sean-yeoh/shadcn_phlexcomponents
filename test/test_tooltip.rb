# frozen_string_literal: true

require "test_helper"

class TestTooltip < ComponentTest
  def test_it_should_render_basic_tooltip
    component = ShadcnPhlexcomponents::Tooltip.new
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="tooltip"')
    assert_includes(output, 'data-controller="tooltip"')
    assert_includes(output, 'data-tooltip-is-open-value="false"')
    assert_includes(output, "inline-flex max-w-fit")
    assert_match(%r{<div[^>]*>.*</div>}m, output)
  end

  def test_it_should_render_with_open_state
    component = ShadcnPhlexcomponents::Tooltip.new(open: true)
    output = render(component)

    assert_includes(output, 'data-tooltip-is-open-value="true"')
  end

  def test_it_should_render_with_custom_attributes
    component = ShadcnPhlexcomponents::Tooltip.new(
      open: false,
      class: "custom-tooltip max-w-xs",
      id: "info-tooltip",
      data: { testid: "tooltip-component" },
    )
    output = render(component)

    assert_includes(output, "custom-tooltip max-w-xs")
    assert_includes(output, 'id="info-tooltip"')
    assert_includes(output, 'data-testid="tooltip-component"')
    assert_includes(output, 'data-tooltip-is-open-value="false"')
  end

  def test_it_should_generate_aria_id
    component = ShadcnPhlexcomponents::Tooltip.new do |tooltip|
      tooltip.trigger { "Test" }
      tooltip.content { "Content" }
    end
    output = render(component)

    # Should have auto-generated aria_id in tooltip content
    assert_match(/tooltip-[a-f0-9]{10}-content/, output)
  end

  def test_it_should_merge_data_attributes
    component = ShadcnPhlexcomponents::Tooltip.new(
      data: {
        controller: "tooltip help-system",
        help_system_target: "tooltipContainer",
        help_system_category: "ui",
      },
    )
    output = render(component)

    # Should merge controllers
    assert_match(/data-controller="[^"]*tooltip[^"]*help-system[^"]*"/, output)
    assert_includes(output, 'data-help-system-target="tooltipContainer"')
    assert_includes(output, 'data-help-system-category="ui"')
  end

  def test_it_should_render_with_helper_methods
    component = ShadcnPhlexcomponents::Tooltip.new do |tooltip|
      tooltip.trigger(class: "trigger-button") { "Hover me" }
      tooltip.content(side: :bottom) { "This is a tooltip" }
    end
    output = render(component)

    # Check that helper methods generate proper content
    assert_includes(output, "Hover me")
    assert_includes(output, "This is a tooltip")
    assert_includes(output, "trigger-button")

    # Should have proper component identifiers for sub-components
    assert_includes(output, 'data-shadcn-phlexcomponents="tooltip-trigger"')
    assert_includes(output, 'data-shadcn-phlexcomponents="tooltip-content"')
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::Tooltip.new
    output = render(component)

    assert_includes(output, "inline-flex")
    assert_includes(output, "max-w-fit")
  end
end

class TestTooltipTrigger < ComponentTest
  def test_it_should_render_tooltip_trigger
    component = ShadcnPhlexcomponents::TooltipTrigger.new(aria_id: "tooltip-12345") { "Trigger" }
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="tooltip-trigger"')
    assert_includes(output, 'role="button"')
    assert_includes(output, 'aria-describedby="tooltip-12345-content"')
    assert_includes(output, 'data-as-child="false"')
    assert_includes(output, 'data-tooltip-target="trigger"')
    assert_includes(output, "Trigger")
    assert_match(%r{<div[^>]*>.*Trigger.*</div>}m, output)
  end

  def test_it_should_render_with_custom_attributes
    component = ShadcnPhlexcomponents::TooltipTrigger.new(
      aria_id: "tooltip-custom",
      class: "custom-trigger hover:bg-muted",
      id: "trigger-id",
      data: { testid: "tooltip-trigger" },
    ) { "Custom Trigger" }
    output = render(component)

    assert_includes(output, "custom-trigger hover:bg-muted")
    assert_includes(output, 'id="trigger-id"')
    assert_includes(output, 'data-testid="tooltip-trigger"')
    assert_includes(output, 'aria-describedby="tooltip-custom-content"')
    assert_includes(output, "Custom Trigger")
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::TooltipTrigger.new(aria_id: "tooltip-test") { "Test" }
    output = render(component)

    assert_includes(output, "focus->tooltip#open")
    assert_includes(output, "blur->tooltip#closeImmediately")
    assert_includes(output, "click->tooltip#open")
  end

  def test_it_should_render_basic_trigger
    component = ShadcnPhlexcomponents::TooltipTrigger.new(
      aria_id: "tooltip-child",
    ) do
      "Button Text"
    end
    output = render(component)

    # Should render basic trigger
    assert_includes(output, "Button Text")
    assert_includes(output, 'data-as-child="false"')
    # Should merge attributes
    assert_includes(output, 'aria-describedby="tooltip-child-content"')
  end

  def test_it_should_handle_custom_actions
    component = ShadcnPhlexcomponents::TooltipTrigger.new(
      aria_id: "tooltip-action",
      data: {
        action: "focus->tooltip#open hover->tooltip#open:delay(500) custom->handler#action",
      },
    ) { "Action Trigger" }
    output = render(component)

    # Should include both default and custom actions
    assert_includes(output, "focus->tooltip#open")
    assert_includes(output, "hover->tooltip#open:delay(500)")
    assert_includes(output, "custom->handler#action")
  end
end

class TestTooltipContent < ComponentTest
  def test_it_should_render_tooltip_content
    component = ShadcnPhlexcomponents::TooltipContent.new(
      aria_id: "tooltip-67890",
    ) { "Tooltip content" }
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="tooltip-content"')
    assert_includes(output, 'data-side="top"')
    assert_includes(output, 'data-align="center"')
    assert_includes(output, 'data-tooltip-target="content"')
    # Check container styling
    assert_match(/style="[^"]*display:\s*none[^"]*"/, output)
    assert_includes(output, "fixed")
    assert_includes(output, "top-0")
    assert_includes(output, "left-0")
    assert_includes(output, "w-max")
    assert_includes(output, "z-50")
    assert_includes(output, "Tooltip content")
  end

  def test_it_should_render_with_custom_side_and_align
    sides = [
      { side: :top, align: :start },
      { side: :bottom, align: :end },
      { side: :left, align: :center },
      { side: :right, align: :center },
    ]

    sides.each do |config|
      component = ShadcnPhlexcomponents::TooltipContent.new(
        side: config[:side],
        align: config[:align],
        aria_id: "tooltip-test",
      ) { "Content" }
      output = render(component)

      assert_includes(output, "data-side=\"#{config[:side]}\"")
      assert_includes(output, "data-align=\"#{config[:align]}\"")
    end
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::TooltipContent.new(aria_id: "tooltip-style") { "Styled" }
    output = render(component)

    # Base styling
    assert_includes(output, "bg-primary")
    assert_includes(output, "text-primary-foreground")
    assert_includes(output, "z-50")
    assert_includes(output, "w-fit")
    assert_includes(output, "rounded-md")
    assert_includes(output, "px-3")
    assert_includes(output, "py-1.5")
    assert_includes(output, "text-xs")
    assert_includes(output, "text-balance")

    # Animation classes
    assert_includes(output, "animate-in fade-in-0 zoom-in-95")
    assert_includes(output, "data-[state=closed]:animate-out")
    assert_includes(output, "data-[state=closed]:fade-out-0")
    assert_includes(output, "data-[state=closed]:zoom-out-95")

    # Side-specific animations
    assert_includes(output, "data-[side=bottom]:slide-in-from-top-2")
    assert_includes(output, "data-[side=left]:slide-in-from-right-2")
    assert_includes(output, "data-[side=right]:slide-in-from-left-2")
    assert_includes(output, "data-[side=top]:slide-in-from-bottom-2")

    # Transform origin
    assert_includes(output, "origin-(--radix-tooltip-content-transform-origin)")
  end

  def test_it_should_include_tooltip_arrow
    component = ShadcnPhlexcomponents::TooltipContent.new(aria_id: "tooltip-arrow") { "With arrow" }
    output = render(component)

    # Should include TooltipArrow component
    assert_includes(output, 'data-shadcn-phlexcomponents="tooltip-arrow"')
    assert_includes(output, 'data-tooltip-target="arrow"')
  end

  def test_it_should_include_sr_only_content
    component = ShadcnPhlexcomponents::TooltipContent.new(
      aria_id: "tooltip-sr",
    ) { "Screen reader content" }
    output = render(component)

    # Should include span with role="tooltip" and sr-only class
    assert_includes(output, 'id="tooltip-sr-content"')
    assert_includes(output, 'role="tooltip"')
    assert_includes(output, 'class="sr-only"')
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::TooltipContent.new(aria_id: "tooltip-action") { "Action" }
    output = render(component)

    assert_includes(output, "mouseover->tooltip#open")
    assert_includes(output, "mouseout->tooltip#close")
  end

  def test_it_should_render_with_custom_attributes
    component = ShadcnPhlexcomponents::TooltipContent.new(
      side: :bottom,
      align: :start,
      aria_id: "tooltip-custom",
      class: "custom-content border border-gray-300",
      data: { testid: "tooltip-content", delay: "200" },
    ) { "Custom content" }
    output = render(component)

    assert_includes(output, "custom-content border border-gray-300")
    assert_includes(output, 'data-testid="tooltip-content"')
    assert_includes(output, 'data-delay="200"')
    assert_includes(output, "data-side=\"bottom\"")
    assert_includes(output, "data-align=\"start\"")
    assert_includes(output, "Custom content")
  end
end

class TestTooltipArrow < ComponentTest
  def test_it_should_render_tooltip_arrow
    component = ShadcnPhlexcomponents::TooltipArrow.new
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="tooltip-arrow"')
    assert_includes(output, 'data-tooltip-target="arrow"')
    assert_includes(output, 'width="10"')
    assert_includes(output, 'height="5"')
    assert_includes(output, 'viewBox="0 0 30 10"')
    assert_includes(output, 'preserveAspectRatio="none"')
    # Should contain SVG polygon
    assert_includes(output, '<polygon points="0,0 30,0 15,10"></polygon>')
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::TooltipArrow.new
    output = render(component)

    assert_includes(output, "bg-primary fill-primary")
    assert_includes(output, "z-50 size-2.5")
    assert_includes(output, "translate-y-[calc(-50%_-_2px)]")
    assert_includes(output, "rotate-45 rounded-[2px]")
  end

  def test_it_should_render_with_custom_attributes
    component = ShadcnPhlexcomponents::TooltipArrow.new(
      class: "custom-arrow bg-blue-500",
      width: 15,
      height: 8,
    )
    output = render(component)

    assert_includes(output, "custom-arrow bg-blue-500")
    assert_includes(output, 'width="15"')
    assert_includes(output, 'height="8"')
  end
end

class TestTooltipWithCustomConfiguration < ComponentTest
  def test_tooltip_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.tooltip = {
      root: { base: "custom-tooltip-base inline-block" },
      content: {
        base: "custom-content-base bg-black text-white p-2 rounded shadow-lg",
      },
      arrow: { base: "custom-arrow-base bg-black" },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload classes
    tooltip_classes = ["TooltipArrow", "TooltipContent", "TooltipTrigger", "Tooltip"]

    tooltip_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/tooltip.rb", __dir__))

    # Test components with custom configuration
    tooltip = ShadcnPhlexcomponents::Tooltip.new
    tooltip_output = render(tooltip)
    assert_includes(tooltip_output, "custom-tooltip-base")
    assert_includes(tooltip_output, "inline-block")

    content = ShadcnPhlexcomponents::TooltipContent.new(aria_id: "test") { "Test" }
    content_output = render(content)
    assert_includes(content_output, "custom-content-base")
    assert_includes(content_output, "bg-black text-white p-2 rounded shadow-lg")

    arrow = ShadcnPhlexcomponents::TooltipArrow.new
    arrow_output = render(arrow)
    assert_includes(arrow_output, "custom-arrow-base")
    assert_includes(arrow_output, "bg-black")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    tooltip_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/tooltip.rb", __dir__))
  end
end

class TestTooltipIntegration < ComponentTest
  def test_help_tooltip
    component = ShadcnPhlexcomponents::Tooltip.new(
      class: "help-tooltip",
      data: {
        controller: "tooltip help-system",
        help_system_target: "helpTooltip",
        help_system_category: "form_help",
      },
    ) do |tooltip|
      tooltip.trigger(
        class: "help-trigger text-muted-foreground hover:text-foreground",
        aria: { label: "Get help for this field" },
      ) { "?" }

      tooltip.content(
        side: :top,
        class: "help-content max-w-xs",
        data: { help_system_target: "helpContent" },
      ) { "Enter your full name as it appears on your ID." }
    end
    output = render(component)

    # Check help tooltip structure
    assert_includes(output, "help-tooltip")
    assert_match(/data-controller="[^"]*tooltip[^"]*help-system[^"]*"/, output)
    assert_includes(output, 'data-help-system-target="helpTooltip"')
    assert_includes(output, 'data-help-system-category="form_help"')

    # Check trigger
    assert_includes(output, "help-trigger text-muted-foreground hover:text-foreground")
    assert_includes(output, 'aria-label="Get help for this field"')
    assert_includes(output, "?")

    # Check content
    assert_includes(output, "help-content max-w-xs")
    assert_includes(output, "data-side=\"top\"")
    assert_includes(output, 'data-help-system-target="helpContent"')
    assert_includes(output, "Enter your full name as it appears on your ID.")
  end

  def test_button_tooltip
    component = ShadcnPhlexcomponents::Tooltip.new(
      class: "button-tooltip",
      data: {
        controller: "tooltip button-enhancer",
        button_enhancer_target: "buttonWithTooltip",
      },
    ) do |tooltip|
      tooltip.trigger(
        class: "enhanced-button",
      ) do
        "Save Changes"
      end

      tooltip.content(
        side: :bottom,
        class: "button-tooltip-content",
      ) { "Please fill in all required fields to enable saving." }
    end
    output = render(component)

    # Check button tooltip structure
    assert_includes(output, "button-tooltip")
    assert_match(/data-controller="[^"]*tooltip[^"]*button-enhancer[^"]*"/, output)
    assert_includes(output, 'data-button-enhancer-target="buttonWithTooltip"')

    # Check trigger without as_child
    assert_includes(output, "enhanced-button")
    assert_includes(output, "Save Changes")
    assert_includes(output, 'data-as-child="false"')

    # Check content
    assert_includes(output, "button-tooltip-content")
    assert_includes(output, "Please fill in all required fields to enable saving.")
  end

  def test_icon_tooltip
    component = ShadcnPhlexcomponents::Tooltip.new(
      class: "icon-tooltip",
      data: {
        controller: "tooltip icon-enhancer analytics",
        analytics_category: "tooltip_interactions",
      },
    ) do |tooltip|
      tooltip.trigger(
        class: "icon-trigger p-1 rounded hover:bg-muted",
        data: { analytics_label: "info_icon" },
      ) { "ℹ️" }

      tooltip.content(
        side: :right,
        align: :start,
        class: "icon-tooltip-content",
      ) { "This feature is currently in beta. Please report any issues." }
    end
    output = render(component)

    # Check icon tooltip structure
    assert_includes(output, "icon-tooltip")
    assert_match(/data-controller="[^"]*tooltip[^"]*icon-enhancer[^"]*analytics[^"]*"/, output)
    assert_includes(output, 'data-analytics-category="tooltip_interactions"')

    # Check trigger
    assert_includes(output, "icon-trigger p-1 rounded hover:bg-muted")
    assert_includes(output, 'data-analytics-label="info_icon"')
    assert_includes(output, "ℹ️")

    # Check content positioning
    assert_includes(output, "icon-tooltip-content")
    assert_includes(output, "data-side=\"right\"")
    assert_includes(output, "data-align=\"start\"")
    assert_includes(output, "This feature is currently in beta. Please report any issues.")
  end

  def test_status_tooltip
    component = ShadcnPhlexcomponents::Tooltip.new(
      open: false,
      class: "status-tooltip",
      data: {
        controller: "tooltip status-monitor",
        status_monitor_target: "statusTooltip",
        status_monitor_status: "online",
      },
    ) do |tooltip|
      tooltip.trigger(
        class: "status-indicator flex items-center gap-2",
      ) do
        "Online"
      end

      tooltip.content(
        side: :bottom,
        class: "status-content",
      ) { "System is operational. Last updated: 2 minutes ago" }
    end
    output = render(component)

    # Check status tooltip structure
    assert_includes(output, "status-tooltip")
    assert_match(/data-controller="[^"]*tooltip[^"]*status-monitor[^"]*"/, output)
    assert_includes(output, 'data-status-monitor-target="statusTooltip"')
    assert_includes(output, 'data-status-monitor-status="online"')

    # Check trigger with status indicator
    assert_includes(output, "status-indicator flex items-center gap-2")
    assert_includes(output, "Online")

    # Check content
    assert_includes(output, "status-content")
    assert_includes(output, "System is operational. Last updated: 2 minutes ago")
  end

  def test_keyboard_tooltip
    component = ShadcnPhlexcomponents::Tooltip.new(
      class: "keyboard-tooltip",
      data: {
        controller: "tooltip keyboard-shortcut",
        keyboard_shortcut_target: "shortcutTooltip",
        keyboard_shortcut_key: "cmd+s",
      },
    ) do |tooltip|
      tooltip.trigger(
        class: "keyboard-trigger",
        tabindex: "0",
        data: {
          action: "focus->tooltip#open blur->tooltip#closeImmediately keydown.escape->tooltip#close",
        },
      ) { "Save" }

      tooltip.content(
        side: :top,
        class: "keyboard-content font-mono text-xs",
      ) { "⌘+S" }
    end
    output = render(component)

    # Check keyboard tooltip structure
    assert_includes(output, "keyboard-tooltip")
    assert_match(/data-controller="[^"]*tooltip[^"]*keyboard-shortcut[^"]*"/, output)
    assert_includes(output, 'data-keyboard-shortcut-target="shortcutTooltip"')
    assert_includes(output, 'data-keyboard-shortcut-key="cmd+s"')

    # Check trigger with keyboard support
    assert_includes(output, "keyboard-trigger")
    assert_includes(output, 'tabindex="0"')
    assert_includes(output, "keydown.escape->tooltip#close")
    assert_includes(output, "Save")

    # Check content with keyboard shortcut
    assert_includes(output, "keyboard-content font-mono text-xs")
    assert_includes(output, "⌘+S")
  end

  def test_tooltip_accessibility_features
    component = ShadcnPhlexcomponents::Tooltip.new(
      class: "accessible-tooltip",
      data: {
        controller: "tooltip accessibility-enhancer",
        accessibility_enhancer_target: "accessibleTooltip",
        accessibility_enhancer_announce: "true",
      },
    ) do |tooltip|
      tooltip.trigger(
        class: "accessible-trigger",
        aria: {
          label: "More information",
          describedby: "tooltip-content",
          keyshortcuts: "F1",
        },
      ) { "More Info" }

      tooltip.content(
        id: "tooltip-content",
        side: :top,
        class: "accessible-content",
        role: "tooltip",
      ) { "Additional context about this feature that helps users understand its purpose." }
    end
    output = render(component)

    # Check accessibility enhancements
    assert_includes(output, "accessible-tooltip")
    assert_match(/data-controller="[^"]*tooltip[^"]*accessibility-enhancer[^"]*"/, output)
    assert_includes(output, 'data-accessibility-enhancer-target="accessibleTooltip"')
    assert_includes(output, 'data-accessibility-enhancer-announce="true"')

    # Check trigger accessibility
    assert_includes(output, "accessible-trigger")
    assert_includes(output, 'aria-label="More information"')
    # The aria-describedby will include both the custom ID and the generated one
    assert_match(/aria-describedby="[^"]*tooltip-content[^"]*"/, output)
    assert_includes(output, 'aria-keyshortcuts="F1"')

    # Check content accessibility
    assert_includes(output, 'id="tooltip-content"')
    assert_includes(output, 'role="tooltip"')
    assert_includes(output, "Additional context about this feature that helps users understand its purpose.")
  end

  def test_tooltip_with_delay_and_animation
    component = ShadcnPhlexcomponents::Tooltip.new(
      class: "animated-tooltip",
      data: {
        controller: "tooltip animation-manager",
        animation_manager_enter_delay: "500",
        animation_manager_exit_delay: "200",
      },
    ) do |tooltip|
      tooltip.trigger(
        class: "animated-trigger transition-colors",
      ) { "Hover for animation" }

      tooltip.content(
        side: :bottom,
        class: "animated-content transition-all duration-200",
      ) { "This tooltip has custom timing!" }
    end
    output = render(component)

    # Check animation setup
    assert_includes(output, "animated-tooltip")
    assert_match(/data-controller="[^"]*tooltip[^"]*animation-manager[^"]*"/, output)
    assert_includes(output, 'data-animation-manager-enter-delay="500"')
    assert_includes(output, 'data-animation-manager-exit-delay="200"')

    # Check animated elements
    assert_includes(output, "animated-trigger transition-colors")
    assert_includes(output, "animated-content transition-all duration-200")
    assert_includes(output, "This tooltip has custom timing!")
  end

  def test_tooltip_with_rich_content
    component = ShadcnPhlexcomponents::Tooltip.new(
      class: "rich-tooltip",
    ) do |tooltip|
      tooltip.trigger(
        class: "rich-trigger underline decoration-dotted",
      ) { "Technical Term" }

      tooltip.content(
        side: :top,
        class: "rich-content max-w-sm p-3",
      ) do
        "A detailed explanation with emphasis and code examples."
      end
    end
    output = render(component)

    # Check rich content structure
    assert_includes(output, "rich-tooltip")
    assert_includes(output, "rich-trigger underline decoration-dotted")
    assert_includes(output, "Technical Term")

    # Check rich content formatting
    assert_includes(output, "rich-content max-w-sm p-3")
    assert_includes(output, "A detailed explanation with emphasis and code examples.")
  end
end
