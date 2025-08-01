# frozen_string_literal: true

require "test_helper"

class TestThemeSwitcher < ComponentTest
  def test_it_should_render_basic_theme_switcher
    component = ShadcnPhlexcomponents::ThemeSwitcher.new
    output = render(component)

    # ThemeSwitcher renders as a Button, so it has button component identifier
    assert_includes(output, 'data-shadcn-phlexcomponents="theme-switcher button"')
    assert_includes(output, 'data-controller="theme-switcher"')
    assert_includes(output, 'data-action="theme-switcher#toggle"')
    assert_match(%r{<button[^>]*>.*</button>}m, output)
  end

  def test_it_should_render_with_button_styling
    component = ShadcnPhlexcomponents::ThemeSwitcher.new
    output = render(component)

    # Check that it renders as a Button component with ghost variant and icon size
    # These classes come from the Button component
    assert_includes(output, "inline-flex items-center justify-center")
    assert_includes(output, "rounded-md text-sm font-medium")
    assert_includes(output, "transition-all")
    assert_includes(output, "disabled:pointer-events-none disabled:opacity-50")
    # Ghost variant styles
    assert_includes(output, "hover:bg-accent hover:text-accent-foreground")
    # Icon size styles
    assert_includes(output, "size-9")
  end

  def test_it_should_render_with_sun_and_moon_icons
    component = ShadcnPhlexcomponents::ThemeSwitcher.new
    output = render(component)

    # Check for sun icon (hidden in light mode, visible in dark mode)
    assert_includes(output, "hidden dark:inline")
    # Check for moon icon (visible in light mode, hidden in dark mode)
    assert_includes(output, "inline dark:hidden")

    # The icons are rendered as SVGs, not with data-lucide attribute
    # We should check for the actual SVG elements instead
  end

  def test_it_should_render_with_custom_attributes
    component = ShadcnPhlexcomponents::ThemeSwitcher.new(
      class: "custom-theme-switcher ml-4",
      id: "theme-toggle",
      aria: { label: "Toggle theme" },
      data: { testid: "theme-button" },
    )
    output = render(component)

    assert_includes(output, "custom-theme-switcher ml-4")
    assert_includes(output, 'id="theme-toggle"')
    assert_includes(output, 'aria-label="Toggle theme"')
    assert_includes(output, 'data-testid="theme-button"')
    # Should still have default controller and action
    assert_includes(output, 'data-controller="theme-switcher"')
    assert_includes(output, 'data-action="theme-switcher#toggle"')
  end

  def test_it_should_merge_data_attributes
    component = ShadcnPhlexcomponents::ThemeSwitcher.new(
      data: {
        controller: "theme-switcher header-controls",
        header_controls_target: "themeToggle",
        action: "theme-switcher#toggle click->header-controls#trackToggle",
      },
    )
    output = render(component)

    # Should merge controllers properly
    assert_match(/data-controller="[^"]*theme-switcher[^"]*header-controls[^"]*"/, output)
    assert_includes(output, 'data-header-controls-target="themeToggle"')
    # Should merge actions
    assert_includes(output, "theme-switcher#toggle")
    assert_includes(output, "header-controls#trackToggle")
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::ThemeSwitcher.new(
      disabled: true,
      aria: { label: "Theme switcher disabled" },
    )
    output = render(component)

    assert_includes(output, "disabled")
    assert_includes(output, 'aria-label="Theme switcher disabled"')
    assert_includes(output, "disabled:pointer-events-none disabled:opacity-50")
  end

  def test_it_should_handle_different_button_variants
    # Test with different size
    large_component = ShadcnPhlexcomponents::ThemeSwitcher.new(
      size: :lg,
      class: "large-theme-switcher",
    )
    large_output = render(large_component)

    assert_includes(large_output, "large-theme-switcher")
    # Large icon size would be different from default

    # Test with different variant (if supported by Button component)
    outline_component = ShadcnPhlexcomponents::ThemeSwitcher.new(
      variant: :outline,
      class: "outline-theme-switcher",
    )
    outline_output = render(outline_component)

    assert_includes(outline_output, "outline-theme-switcher")
  end

  def test_it_should_render_accessible_structure
    component = ShadcnPhlexcomponents::ThemeSwitcher.new(
      aria: {
        label: "Toggle between light and dark theme",
        pressed: "false",
      },
    )
    output = render(component)

    assert_includes(output, 'aria-label="Toggle between light and dark theme"')
    assert_includes(output, 'aria-pressed="false"')
    assert_includes(output, 'type="button"')
  end

  def test_it_should_work_with_tooltip
    component = ShadcnPhlexcomponents::ThemeSwitcher.new(
      class: "theme-switcher-with-tooltip",
      data: {
        controller: "theme-switcher tooltip",
        tooltip_content: "Switch theme",
        tooltip_position: "bottom",
      },
    )
    output = render(component)

    assert_includes(output, "theme-switcher-with-tooltip")
    assert_match(/data-controller="[^"]*theme-switcher[^"]*tooltip[^"]*"/, output)
    assert_includes(output, 'data-tooltip-content="Switch theme"')
    assert_includes(output, 'data-tooltip-position="bottom"')
  end
end

class TestThemeSwitcherIntegration < ComponentTest
  def test_navbar_theme_switcher
    component = ShadcnPhlexcomponents::ThemeSwitcher.new(
      class: "navbar-theme-switcher",
      aria: { label: "Toggle light/dark theme" },
      data: {
        controller: "theme-switcher navbar-controls analytics",
        navbar_controls_target: "themeToggle",
        analytics_category: "ui",
        analytics_label: "theme_toggle",
        action: "theme-switcher#toggle click->navbar-controls#updateTheme click->analytics#track",
      },
    )
    output = render(component)

    # Check navbar integration
    assert_includes(output, "navbar-theme-switcher")
    assert_includes(output, 'aria-label="Toggle light/dark theme"')

    # Check multiple controllers
    assert_match(/data-controller="[^"]*theme-switcher[^"]*navbar-controls[^"]*analytics[^"]*"/, output)
    assert_includes(output, 'data-navbar-controls-target="themeToggle"')
    assert_includes(output, 'data-analytics-category="ui"')
    assert_includes(output, 'data-analytics-label="theme_toggle"')

    # Check multiple actions
    assert_includes(output, "theme-switcher#toggle")
    assert_includes(output, "navbar-controls#updateTheme")
    assert_includes(output, "analytics#track")

    # Check icons are present as SVGs with proper visibility classes
    assert_includes(output, "hidden dark:inline")
    assert_includes(output, "inline dark:hidden")
  end

  def test_settings_page_theme_switcher
    component = ShadcnPhlexcomponents::ThemeSwitcher.new(
      class: "settings-theme-switcher border rounded-md",
      size: :lg,
      aria: {
        label: "Change application theme",
        describedby: "theme-description",
      },
      data: {
        controller: "theme-switcher settings-manager",
        settings_manager_target: "themeControl",
        settings_manager_setting: "theme",
        action: "theme-switcher#toggle change->settings-manager#saveSetting",
      },
    )
    output = render(component)

    # Check settings page styling
    assert_includes(output, "settings-theme-switcher border rounded-md")
    assert_includes(output, 'aria-label="Change application theme"')
    assert_includes(output, 'aria-describedby="theme-description"')

    # Check settings integration
    assert_match(/data-controller="[^"]*theme-switcher[^"]*settings-manager[^"]*"/, output)
    assert_includes(output, 'data-settings-manager-target="themeControl"')
    assert_includes(output, 'data-settings-manager-setting="theme"')
    assert_includes(output, "settings-manager#saveSetting")
  end

  def test_mobile_theme_switcher
    component = ShadcnPhlexcomponents::ThemeSwitcher.new(
      class: "mobile-theme-switcher sm:hidden",
      size: :sm,
      data: {
        controller: "theme-switcher mobile-menu",
        mobile_menu_target: "themeButton",
        action: "theme-switcher#toggle click->mobile-menu#closeMenu",
      },
    )
    output = render(component)

    # Check mobile styling
    assert_includes(output, "mobile-theme-switcher sm:hidden")

    # Check mobile menu integration
    assert_match(/data-controller="[^"]*theme-switcher[^"]*mobile-menu[^"]*"/, output)
    assert_includes(output, 'data-mobile-menu-target="themeButton"')
    assert_includes(output, "mobile-menu#closeMenu")
  end

  def test_theme_switcher_with_system_preference
    component = ShadcnPhlexcomponents::ThemeSwitcher.new(
      class: "system-theme-switcher",
      aria: { label: "Toggle theme (Auto/Light/Dark)" },
      data: {
        controller: "theme-switcher system-preferences",
        system_preferences_target: "themeToggle",
        system_preferences_modes: ["system", "light", "dark"].to_json,
        system_preferences_current: "system",
        action: "theme-switcher#toggle click->system-preferences#cycleTheme",
      },
    )
    output = render(component)

    # Check system preference integration
    assert_includes(output, "system-theme-switcher")
    assert_includes(output, 'aria-label="Toggle theme (Auto/Light/Dark)"')

    # Check system preferences data
    assert_match(/data-controller="[^"]*theme-switcher[^"]*system-preferences[^"]*"/, output)
    assert_includes(output, 'data-system-preferences-target="themeToggle"')
    assert_includes(output, 'data-system-preferences-modes="[&quot;system&quot;,&quot;light&quot;,&quot;dark&quot;]"')
    assert_includes(output, 'data-system-preferences-current="system"')
    assert_includes(output, "system-preferences#cycleTheme")
  end

  def test_theme_switcher_with_animation
    component = ShadcnPhlexcomponents::ThemeSwitcher.new(
      class: "animated-theme-switcher transition-transform hover:scale-110",
      data: {
        controller: "theme-switcher theme-animation",
        theme_animation_target: "button",
        theme_animation_duration: "300",
        action: "theme-switcher#toggle click->theme-animation#animate",
      },
    )
    output = render(component)

    # Check animation classes
    assert_includes(output, "animated-theme-switcher")
    assert_includes(output, "transition-transform hover:scale-110")

    # Check animation integration
    assert_match(/data-controller="[^"]*theme-switcher[^"]*theme-animation[^"]*"/, output)
    assert_includes(output, 'data-theme-animation-target="button"')
    assert_includes(output, 'data-theme-animation-duration="300"')
    assert_includes(output, "theme-animation#animate")
  end

  def test_theme_switcher_with_custom_icons
    component = ShadcnPhlexcomponents::ThemeSwitcher.new(
      class: "custom-icon-theme-switcher",
      data: {
        controller: "theme-switcher custom-icons",
        custom_icons_light_icon: "sun-bright",
        custom_icons_dark_icon: "moon-stars",
        action: "theme-switcher#toggle change->custom-icons#updateIcons",
      },
    )
    output = render(component)

    # Check custom icon integration
    assert_includes(output, "custom-icon-theme-switcher")
    assert_match(/data-controller="[^"]*theme-switcher[^"]*custom-icons[^"]*"/, output)
    assert_includes(output, 'data-custom-icons-light-icon="sun-bright"')
    assert_includes(output, 'data-custom-icons-dark-icon="moon-stars"')
    assert_includes(output, "custom-icons#updateIcons")

    # Should still have the default icons in markup as SVGs
    assert_includes(output, "hidden dark:inline")
    assert_includes(output, "inline dark:hidden")
  end

  def test_theme_switcher_accessibility_enhanced
    component = ShadcnPhlexcomponents::ThemeSwitcher.new(
      class: "accessible-theme-switcher",
      aria: {
        label: "Switch color theme",
        keyshortcuts: "Ctrl+Shift+L",
        live: "polite",
      },
      data: {
        controller: "theme-switcher accessibility-enhancer",
        accessibility_enhancer_target: "themeButton",
        accessibility_enhancer_announce: "true",
        action: "theme-switcher#toggle change->accessibility-enhancer#announceChange",
      },
    )
    output = render(component)

    # Check enhanced accessibility
    assert_includes(output, "accessible-theme-switcher")
    assert_includes(output, 'aria-label="Switch color theme"')
    assert_includes(output, 'aria-keyshortcuts="Ctrl+Shift+L"')
    assert_includes(output, 'aria-live="polite"')

    # Check accessibility enhancer integration
    assert_match(/data-controller="[^"]*theme-switcher[^"]*accessibility-enhancer[^"]*"/, output)
    assert_includes(output, 'data-accessibility-enhancer-target="themeButton"')
    assert_includes(output, 'data-accessibility-enhancer-announce="true"')
    assert_includes(output, "accessibility-enhancer#announceChange")
  end

  def test_theme_switcher_with_persistence
    component = ShadcnPhlexcomponents::ThemeSwitcher.new(
      class: "persistent-theme-switcher",
      data: {
        controller: "theme-switcher local-storage",
        local_storage_key: "user-theme-preference",
        local_storage_target: "themeToggle",
        action: "theme-switcher#toggle change->local-storage#save",
      },
    )
    output = render(component)

    # Check persistence integration
    assert_includes(output, "persistent-theme-switcher")
    assert_match(/data-controller="[^"]*theme-switcher[^"]*local-storage[^"]*"/, output)
    assert_includes(output, 'data-local-storage-key="user-theme-preference"')
    assert_includes(output, 'data-local-storage-target="themeToggle"')
    assert_includes(output, "local-storage#save")
  end

  def test_theme_switcher_with_status_indicator
    component = ShadcnPhlexcomponents::ThemeSwitcher.new(
      class: "theme-switcher-with-status relative",
      aria: {
        label: "Theme switcher",
        describedby: "theme-status",
      },
      data: {
        controller: "theme-switcher status-indicator",
        status_indicator_target: "button",
        status_indicator_current_theme: "light",
        action: "theme-switcher#toggle change->status-indicator#updateStatus",
      },
    )
    output = render(component)

    # Check status indicator integration
    assert_includes(output, "theme-switcher-with-status relative")
    assert_includes(output, 'aria-describedby="theme-status"')

    # Check status indicator data
    assert_match(/data-controller="[^"]*theme-switcher[^"]*status-indicator[^"]*"/, output)
    assert_includes(output, 'data-status-indicator-target="button"')
    assert_includes(output, 'data-status-indicator-current-theme="light"')
    assert_includes(output, "status-indicator#updateStatus")
  end

  def test_theme_switcher_keyboard_navigation
    component = ShadcnPhlexcomponents::ThemeSwitcher.new(
      class: "keyboard-theme-switcher",
      tabindex: "0",
      data: {
        controller: "theme-switcher keyboard-navigation",
        keyboard_navigation_target: "focusable",
        action: "theme-switcher#toggle keydown.space->theme-switcher#toggle:prevent keydown.enter->theme-switcher#toggle",
      },
    )
    output = render(component)

    # Check keyboard navigation
    assert_includes(output, "keyboard-theme-switcher")
    assert_includes(output, 'tabindex="0"')

    # Check keyboard actions
    assert_match(/data-controller="[^"]*theme-switcher[^"]*keyboard-navigation[^"]*"/, output)
    assert_includes(output, 'data-keyboard-navigation-target="focusable"')
    assert_includes(output, "keydown.space->theme-switcher#toggle:prevent")
    assert_includes(output, "keydown.enter->theme-switcher#toggle")
  end
end
