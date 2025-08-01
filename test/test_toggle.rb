# frozen_string_literal: true

require "test_helper"

class TestToggle < ComponentTest
  def test_it_should_render_basic_toggle
    component = ShadcnPhlexcomponents::Toggle.new
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="toggle"')
    assert_includes(output, 'data-controller="toggle"')
    assert_includes(output, 'data-action="click->toggle#toggle"')
    assert_includes(output, 'aria-pressed="false"')
    assert_includes(output, 'data-toggle-is-on-value="false"')
    assert_match(%r{<button[^>]*>.*</button>}m, output)
  end

  def test_it_should_render_with_default_variant_and_size
    component = ShadcnPhlexcomponents::Toggle.new
    output = render(component)

    # Default variant (default)
    assert_includes(output, "bg-transparent")

    # Default size (default)
    assert_includes(output, "h-9 px-2 min-w-9")

    # Base styling
    assert_includes(output, "inline-flex items-center justify-center gap-2")
    assert_includes(output, "rounded-md text-sm font-medium")
    assert_includes(output, "hover:bg-muted")
    assert_includes(output, "hover:text-muted-foreground")
    assert_includes(output, "disabled:pointer-events-none disabled:opacity-50")
  end

  def test_it_should_render_with_variants
    variants = [
      { variant: :default, expected: "bg-transparent" },
      { variant: :outline, expected: "border border-input bg-transparent shadow-xs" },
    ]

    variants.each do |config|
      component = ShadcnPhlexcomponents::Toggle.new(variant: config[:variant])
      output = render(component)

      assert_includes(output, config[:expected])
      assert_includes(output, "inline-flex items-center justify-center")
    end
  end

  def test_it_should_render_with_sizes
    sizes = [
      { size: :sm, expected: "h-8 px-1.5 min-w-8" },
      { size: :default, expected: "h-9 px-2 min-w-9" },
      { size: :lg, expected: "h-10 px-2.5 min-w-10" },
    ]

    sizes.each do |config|
      component = ShadcnPhlexcomponents::Toggle.new(size: config[:size])
      output = render(component)

      assert_includes(output, config[:expected])
    end
  end

  def test_it_should_render_with_on_state
    component = ShadcnPhlexcomponents::Toggle.new(on: true)
    output = render(component)

    assert_includes(output, 'aria-pressed="true"')
    assert_includes(output, 'data-toggle-is-on-value="true"')
    # Should include the on state styling
    assert_includes(output, "data-[state=on]:bg-accent")
    assert_includes(output, "data-[state=on]:text-accent-foreground")
  end

  def test_it_should_render_with_custom_attributes
    component = ShadcnPhlexcomponents::Toggle.new(
      variant: :outline,
      size: :lg,
      on: true,
      class: "custom-toggle border-blue-500",
      id: "feature-toggle",
      data: { testid: "toggle-button" },
    )
    output = render(component)

    assert_includes(output, "custom-toggle border-blue-500")
    assert_includes(output, 'id="feature-toggle"')
    assert_includes(output, 'data-testid="toggle-button"')
    assert_includes(output, 'aria-pressed="true"')
    assert_includes(output, "border border-input bg-transparent shadow-xs")
    assert_includes(output, "h-10 px-2.5 min-w-10")
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::Toggle.new(
      on: true,
      disabled: true,
      class: "disabled-toggle",
    )
    output = render(component)

    assert_includes(output, "disabled-toggle")
    assert_includes(output, "disabled")
    assert_includes(output, 'aria-pressed="true"')
    assert_includes(output, "disabled:pointer-events-none disabled:opacity-50")
  end

  def test_it_should_merge_data_attributes
    component = ShadcnPhlexcomponents::Toggle.new(
      data: {
        controller: "toggle feature-manager",
        feature_manager_target: "toggleButton",
        feature_manager_feature: "dark_mode",
        action: "click->toggle#toggle change->feature-manager#updateFeature",
      },
    )
    output = render(component)

    # Should merge controllers
    assert_match(/data-controller="[^"]*toggle[^"]*feature-manager[^"]*"/, output)
    assert_includes(output, 'data-feature-manager-target="toggleButton"')
    assert_includes(output, 'data-feature-manager-feature="dark_mode"')
    # Should merge actions
    assert_includes(output, "toggle#toggle")
    assert_includes(output, "feature-manager#updateFeature")
  end

  def test_it_should_handle_aria_attributes
    component = ShadcnPhlexcomponents::Toggle.new(
      on: false,
      aria: {
        label: "Toggle dark mode",
        describedby: "toggle-help",
      },
    )
    output = render(component)

    assert_includes(output, 'aria-pressed="false"')
    assert_includes(output, 'aria-label="Toggle dark mode"')
    assert_includes(output, 'aria-describedby="toggle-help"')
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::Toggle.new
    output = render(component)

    # Base layout and interaction
    assert_includes(output, "inline-flex items-center justify-center gap-2")
    assert_includes(output, "rounded-md text-sm font-medium")
    assert_includes(output, "whitespace-nowrap")

    # Hover and disabled states
    assert_includes(output, "hover:bg-muted")
    assert_includes(output, "hover:text-muted-foreground")
    assert_includes(output, "disabled:pointer-events-none disabled:opacity-50")

    # Toggle states
    assert_includes(output, "data-[state=on]:bg-accent")
    assert_includes(output, "data-[state=on]:text-accent-foreground")

    # Focus and accessibility
    assert_includes(output, "focus-visible:border-ring")
    assert_includes(output, "focus-visible:ring-ring/50")
    assert_includes(output, "focus-visible:ring-[3px]")
    assert_includes(output, "outline-none")

    # Invalid states
    assert_includes(output, "aria-invalid:ring-destructive/20")
    assert_includes(output, "aria-invalid:border-destructive")

    # Transitions
    assert_includes(output, "transition-[color,box-shadow]")

    # SVG styling
    assert_includes(output, "[&_svg]:pointer-events-none")
    assert_includes(output, "[&_svg:not([class*='size-'])]:size-4")
    assert_includes(output, "[&_svg]:shrink-0")
  end

  def test_it_should_render_with_content
    component = ShadcnPhlexcomponents::Toggle.new(on: true) { "Toggle Me" }
    output = render(component)

    assert_includes(output, "Toggle Me")
    assert_includes(output, 'aria-pressed="true"')
  end

  def test_it_should_handle_validation_states
    # Valid state
    valid_component = ShadcnPhlexcomponents::Toggle.new(
      class: "valid-toggle",
      aria: { invalid: "false" },
    )
    valid_output = render(valid_component)

    assert_includes(valid_output, "valid-toggle")
    assert_includes(valid_output, 'aria-invalid="false"')

    # Invalid state
    invalid_component = ShadcnPhlexcomponents::Toggle.new(
      class: "invalid-toggle border-red-500",
      aria: { invalid: "true", describedby: "toggle-error" },
    )
    invalid_output = render(invalid_component)

    assert_includes(invalid_output, "invalid-toggle border-red-500")
    assert_includes(invalid_output, 'aria-invalid="true"')
    assert_includes(invalid_output, 'aria-describedby="toggle-error"')
    assert_includes(invalid_output, "aria-invalid:ring-destructive/20")
    assert_includes(invalid_output, "aria-invalid:border-destructive")
  end

  def test_it_should_handle_different_button_types
    component = ShadcnPhlexcomponents::Toggle.new(
      type: "submit",
      form: "settings-form",
    )
    output = render(component)

    assert_includes(output, 'type="submit"')
    assert_includes(output, 'form="settings-form"')
  end

  def test_it_should_work_with_icons
    component = ShadcnPhlexcomponents::Toggle.new(
      variant: :outline,
      size: :sm,
      class: "icon-toggle",
    ) { "🌙" }
    output = render(component)

    assert_includes(output, "icon-toggle")
    assert_includes(output, "🌙")
    assert_includes(output, "h-8 px-1.5 min-w-8")
    assert_includes(output, "border border-input")
    # SVG classes should be present even with emoji content
    assert_includes(output, "[&_svg:not([class*='size-'])]:size-4")
  end
end

class TestToggleWithCustomConfiguration < ComponentTest
  def test_toggle_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.toggle = {
      base: "custom-toggle-base rounded-full p-2 transition-colors",
      variants: {
        variant: {
          default: "custom-default bg-gray-100 hover:bg-gray-200",
          outline: "custom-outline border-2 border-blue-500 bg-white",
        },
        size: {
          default: "custom-default-size h-10 w-10",
          lg: "custom-lg-size h-12 w-12",
        },
      },
      defaults: {
        variant: :outline,
        size: :lg,
      },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload class
    ShadcnPhlexcomponents.send(:remove_const, :Toggle) if ShadcnPhlexcomponents.const_defined?(:Toggle)
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/toggle.rb", __dir__))

    # Test component with custom configuration - component still uses its own defaults
    toggle = ShadcnPhlexcomponents::Toggle.new
    toggle_output = render(toggle)
    assert_includes(toggle_output, "custom-toggle-base")
    assert_includes(toggle_output, "rounded-full")
    assert_includes(toggle_output, "p-2")
    assert_includes(toggle_output, "transition-colors")
    assert_includes(toggle_output, "custom-default")
    assert_includes(toggle_output, "bg-gray-100")
    assert_includes(toggle_output, "hover:bg-gray-200")
    assert_includes(toggle_output, "custom-default-size")
    assert_includes(toggle_output, "h-10")
    assert_includes(toggle_output, "w-10")

    # Test with different variant
    default_toggle = ShadcnPhlexcomponents::Toggle.new(variant: :default, size: :default)
    default_output = render(default_toggle)
    assert_includes(default_output, "custom-default")
    assert_includes(default_output, "bg-gray-100 hover:bg-gray-200")
    assert_includes(default_output, "custom-default-size")
    assert_includes(default_output, "h-10 w-10")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    ShadcnPhlexcomponents.send(:remove_const, :Toggle) if ShadcnPhlexcomponents.const_defined?(:Toggle)
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/toggle.rb", __dir__))
  end
end

class TestToggleIntegration < ComponentTest
  def test_dark_mode_toggle
    component = ShadcnPhlexcomponents::Toggle.new(
      variant: :outline,
      size: :default,
      on: false,
      class: "dark-mode-toggle",
      aria: {
        label: "Toggle dark mode",
        describedby: "dark-mode-help",
      },
      data: {
        controller: "toggle theme-manager",
        theme_manager_target: "darkModeToggle",
        theme_manager_theme: "system",
        action: "click->toggle#toggle change->theme-manager#updateTheme",
      },
    ) { "🌙" }
    output = render(component)

    # Check dark mode toggle structure
    assert_includes(output, "dark-mode-toggle")
    assert_includes(output, 'aria-pressed="false"')
    assert_includes(output, 'aria-label="Toggle dark mode"')
    assert_includes(output, 'aria-describedby="dark-mode-help"')
    assert_includes(output, "border border-input bg-transparent shadow-xs")

    # Check theme integration
    assert_match(/data-controller="[^"]*toggle[^"]*theme-manager[^"]*"/, output)
    assert_includes(output, 'data-theme-manager-target="darkModeToggle"')
    assert_includes(output, 'data-theme-manager-theme="system"')
    assert_includes(output, "theme-manager#updateTheme")

    # Check content
    assert_includes(output, "🌙")
  end

  def test_feature_flag_toggle
    component = ShadcnPhlexcomponents::Toggle.new(
      variant: :default,
      size: :sm,
      on: true,
      class: "feature-toggle border-l-4 border-l-green-500",
      data: {
        controller: "toggle feature-flags analytics",
        feature_flags_target: "featureToggle",
        feature_flags_flag: "new_dashboard",
        analytics_category: "feature_flags",
        action: "click->toggle#toggle change->feature-flags#updateFlag change->analytics#track",
      },
    ) { "New Dashboard" }
    output = render(component)

    # Check feature toggle structure
    assert_includes(output, "feature-toggle border-l-4 border-l-green-500")
    assert_includes(output, 'aria-pressed="true"')
    assert_includes(output, "h-8 px-1.5 min-w-8")

    # Check feature flag integration
    assert_match(/data-controller="[^"]*toggle[^"]*feature-flags[^"]*analytics[^"]*"/, output)
    assert_includes(output, 'data-feature-flags-target="featureToggle"')
    assert_includes(output, 'data-feature-flags-flag="new_dashboard"')
    assert_includes(output, 'data-analytics-category="feature_flags"')

    # Check multiple actions
    assert_includes(output, "toggle#toggle")
    assert_includes(output, "feature-flags#updateFlag")
    assert_includes(output, "analytics#track")

    # Check content
    assert_includes(output, "New Dashboard")
  end

  def test_notification_toggle
    component = ShadcnPhlexcomponents::Toggle.new(
      variant: :outline,
      size: :lg,
      on: false,
      class: "notification-toggle",
      aria: {
        label: "Enable notifications",
        describedby: "notification-settings",
      },
      data: {
        controller: "toggle notification-manager",
        notification_manager_target: "notificationToggle",
        notification_manager_permission: "notifications",
        action: "click->toggle#toggle change->notification-manager#requestPermission",
      },
    ) { "🔔" }
    output = render(component)

    # Check notification toggle structure
    assert_includes(output, "notification-toggle")
    assert_includes(output, 'aria-pressed="false"')
    assert_includes(output, 'aria-label="Enable notifications"')
    assert_includes(output, 'aria-describedby="notification-settings"')
    assert_includes(output, "h-10 px-2.5 min-w-10")

    # Check notification integration
    assert_match(/data-controller="[^"]*toggle[^"]*notification-manager[^"]*"/, output)
    assert_includes(output, 'data-notification-manager-target="notificationToggle"')
    assert_includes(output, 'data-notification-manager-permission="notifications"')
    assert_includes(output, "notification-manager#requestPermission")

    # Check content
    assert_includes(output, "🔔")
  end

  def test_sidebar_collapse_toggle
    component = ShadcnPhlexcomponents::Toggle.new(
      variant: :default,
      size: :default,
      on: false,
      class: "sidebar-toggle bg-muted/50 hover:bg-muted",
      aria: {
        label: "Collapse sidebar",
        expanded: "true",
      },
      data: {
        controller: "toggle sidebar-controller",
        sidebar_controller_target: "collapseToggle",
        sidebar_controller_sidebar: "main-sidebar",
        action: "click->toggle#toggle change->sidebar-controller#toggleSidebar",
      },
    ) { "⟨" }
    output = render(component)

    # Check sidebar toggle structure
    assert_includes(output, "sidebar-toggle bg-muted/50 hover:bg-muted")
    assert_includes(output, 'aria-pressed="false"')
    assert_includes(output, 'aria-label="Collapse sidebar"')
    assert_includes(output, 'aria-expanded="true"')

    # Check sidebar integration
    assert_match(/data-controller="[^"]*toggle[^"]*sidebar-controller[^"]*"/, output)
    assert_includes(output, 'data-sidebar-controller-target="collapseToggle"')
    assert_includes(output, 'data-sidebar-controller-sidebar="main-sidebar"')
    assert_includes(output, "sidebar-controller#toggleSidebar")

    # Check content
    assert_includes(output, "⟨")
  end

  def test_accessibility_toggle
    component = ShadcnPhlexcomponents::Toggle.new(
      variant: :outline,
      size: :sm,
      on: true,
      class: "accessibility-toggle",
      aria: {
        label: "Enable high contrast mode",
        describedby: "accessibility-help",
        keyshortcuts: "Alt+H",
      },
      data: {
        controller: "toggle accessibility-manager",
        accessibility_manager_target: "contrastToggle",
        accessibility_manager_mode: "high_contrast",
        action: "click->toggle#toggle change->accessibility-manager#updateAccessibility",
      },
    ) { "◐" }
    output = render(component)

    # Check accessibility toggle structure
    assert_includes(output, "accessibility-toggle")
    assert_includes(output, 'aria-pressed="true"')
    assert_includes(output, 'aria-label="Enable high contrast mode"')
    assert_includes(output, 'aria-describedby="accessibility-help"')
    assert_includes(output, 'aria-keyshortcuts="Alt+H"')

    # Check accessibility integration
    assert_match(/data-controller="[^"]*toggle[^"]*accessibility-manager[^"]*"/, output)
    assert_includes(output, 'data-accessibility-manager-target="contrastToggle"')
    assert_includes(output, 'data-accessibility-manager-mode="high_contrast"')
    assert_includes(output, "accessibility-manager#updateAccessibility")

    # Check content
    assert_includes(output, "◐")
  end

  def test_auto_save_toggle
    component = ShadcnPhlexcomponents::Toggle.new(
      variant: :default,
      size: :default,
      on: true,
      class: "auto-save-toggle",
      data: {
        controller: "toggle auto-save-manager",
        auto_save_manager_target: "autoSaveToggle",
        auto_save_manager_interval: "30000",
        action: "click->toggle#toggle change->auto-save-manager#toggleAutoSave",
      },
    ) { "💾 Auto-save" }
    output = render(component)

    # Check auto-save toggle structure
    assert_includes(output, "auto-save-toggle")
    assert_includes(output, 'aria-pressed="true"')

    # Check auto-save integration
    assert_match(/data-controller="[^"]*toggle[^"]*auto-save-manager[^"]*"/, output)
    assert_includes(output, 'data-auto-save-manager-target="autoSaveToggle"')
    assert_includes(output, 'data-auto-save-manager-interval="30000"')
    assert_includes(output, "auto-save-manager#toggleAutoSave")

    # Check content
    assert_includes(output, "💾 Auto-save")
  end

  def test_toggle_with_keyboard_support
    component = ShadcnPhlexcomponents::Toggle.new(
      class: "keyboard-toggle",
      tabindex: "0",
      data: {
        controller: "toggle keyboard-navigation",
        keyboard_navigation_target: "focusable",
        action: "click->toggle#toggle keydown.space->toggle#toggle:prevent keydown.enter->toggle#toggle",
      },
    ) { "Toggle" }
    output = render(component)

    # Check keyboard support
    assert_includes(output, "keyboard-toggle")
    assert_includes(output, 'tabindex="0"')

    # Check keyboard navigation
    assert_match(/data-controller="[^"]*toggle[^"]*keyboard-navigation[^"]*"/, output)
    assert_includes(output, 'data-keyboard-navigation-target="focusable"')
    assert_includes(output, "keydown.space->toggle#toggle:prevent")
    assert_includes(output, "keydown.enter->toggle#toggle")
  end

  def test_toggle_with_confirmation
    component = ShadcnPhlexcomponents::Toggle.new(
      variant: :outline,
      on: false,
      class: "confirmation-toggle border-red-200",
      data: {
        controller: "toggle confirmation-dialog",
        confirmation_dialog_target: "dangerousToggle",
        confirmation_dialog_message: "This will delete all data. Are you sure?",
        action: "click->confirmation-dialog#confirm",
      },
    ) { "⚠️ Danger Zone" }
    output = render(component)

    # Check confirmation toggle structure
    assert_includes(output, "confirmation-toggle border-red-200")
    assert_includes(output, 'aria-pressed="false"')

    # Check confirmation integration
    assert_match(/data-controller="[^"]*toggle[^"]*confirmation-dialog[^"]*"/, output)
    assert_includes(output, 'data-confirmation-dialog-target="dangerousToggle"')
    assert_includes(output, 'data-confirmation-dialog-message="This will delete all data. Are you sure?"')
    assert_includes(output, "confirmation-dialog#confirm")

    # Check content
    assert_includes(output, "⚠️ Danger Zone")
  end
end
