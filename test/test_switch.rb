# frozen_string_literal: true

require "test_helper"

class TestSwitch < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::Switch.new(
      name: "notifications",
      checked: false,
    )
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="switch"')
    assert_includes(output, 'type="button"')
    assert_includes(output, 'role="switch"')
    assert_includes(output, 'aria-checked="false"')
    assert_includes(output, 'data-state="unchecked"')
    assert_includes(output, 'data-controller="switch"')
    assert_includes(output, 'data-action="click->switch#toggle"')
    assert_includes(output, 'data-switch-is-checked-value="false"')
    assert_match(%r{<button[^>]*>.*</button>}m, output)
  end

  def test_it_should_render_with_default_values
    component = ShadcnPhlexcomponents::Switch.new
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="switch"')
    assert_includes(output, 'aria-checked="false"')
    assert_includes(output, 'data-state="unchecked"')
    assert_includes(output, 'data-switch-is-checked-value="false"')
  end

  def test_it_should_render_checked_state
    component = ShadcnPhlexcomponents::Switch.new(
      name: "enable_feature",
      checked: true,
    )
    output = render(component)

    assert_includes(output, 'aria-checked="true"')
    assert_includes(output, 'data-state="checked"')
    assert_includes(output, 'data-switch-is-checked-value="true"')
    # Check hidden checkbox is checked
    assert_includes(output, "checked")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Switch.new(
      name: "custom_switch",
      value: "enabled",
      unchecked_value: "disabled",
      class: "custom-switch",
      id: "switch-id",
      data: { testid: "feature-toggle" },
    )
    output = render(component)

    assert_includes(output, "custom-switch")
    assert_includes(output, 'id="switch-id"')
    assert_includes(output, 'data-testid="feature-toggle"')
    assert_includes(output, 'value="enabled"')
    assert_includes(output, 'value="disabled"')
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::Switch.new(
      name: "disabled_switch",
      disabled: true,
      checked: true,
    )
    output = render(component)

    assert_includes(output, "disabled")
    assert_includes(output, 'aria-checked="true"')
    assert_includes(output, 'data-state="checked"')
  end

  def test_it_should_include_hidden_input_by_default
    component = ShadcnPhlexcomponents::Switch.new(
      name: "test_switch",
      unchecked_value: "off",
    )
    output = render(component)

    assert_includes(output, 'type="hidden"')
    assert_includes(output, 'name="test_switch"')
    assert_includes(output, 'value="off"')
    assert_includes(output, 'autocomplete="off"')
  end

  def test_it_should_exclude_hidden_input_when_disabled
    component = ShadcnPhlexcomponents::Switch.new(
      name: "test_switch",
      include_hidden: false,
    )
    output = render(component)

    # Should not include hidden input
    refute_includes(output, 'type="hidden"')
    # But should still include checkbox
    assert_includes(output, 'type="checkbox"')
  end

  def test_it_should_include_checkbox_input
    component = ShadcnPhlexcomponents::Switch.new(
      name: "checkbox_test",
      value: "yes",
      checked: true,
    )
    output = render(component)

    assert_includes(output, 'type="checkbox"')
    assert_includes(output, 'name="checkbox_test"')
    assert_includes(output, 'value="yes"')
    assert_includes(output, "checked")
    assert_includes(output, 'tabindex="-1"')
    assert_includes(output, 'aria-hidden="true"')
    assert_includes(output, 'data-switch-target="input"')
    assert_includes(output, "opacity-0")
    assert_includes(output, "pointer-events-none")
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::Switch.new(name: "style_test")
    output = render(component)

    assert_includes(output, "peer")
    assert_includes(output, "data-[state=checked]:bg-primary")
    assert_includes(output, "data-[state=unchecked]:bg-input")
    assert_includes(output, "focus-visible:border-ring")
    assert_includes(output, "focus-visible:ring-ring/50")
    assert_includes(output, "inline-flex")
    assert_includes(output, "h-[1.15rem]")
    assert_includes(output, "w-8")
    assert_includes(output, "shrink-0 items-center rounded-full")
    assert_includes(output, "border border-transparent shadow-xs")
    assert_includes(output, "transition-all")
    assert_includes(output, "outline-none")
    assert_includes(output, "disabled:cursor-not-allowed disabled:opacity-50")
  end

  def test_it_should_include_switch_thumb
    component = ShadcnPhlexcomponents::Switch.new(
      name: "thumb_test",
      checked: true,
    )
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="switch-thumb"')
    assert_includes(output, 'data-switch-target="thumb"')
    assert_includes(output, 'data-state="checked"')
  end

  def test_it_should_handle_aria_attributes
    component = ShadcnPhlexcomponents::Switch.new(
      name: "aria_test",
      aria: {
        label: "Enable notifications",
        describedby: "switch-help",
      },
    )
    output = render(component)

    assert_includes(output, 'aria-label="Enable notifications"')
    assert_includes(output, 'aria-describedby="switch-help"')
    assert_includes(output, 'role="switch"')
  end

  def test_it_should_handle_data_attributes
    component = ShadcnPhlexcomponents::Switch.new(
      name: "data_test",
      data: {
        controller: "switch form-field",
        form_field_target: "toggleSwitch",
        action: "click->switch#toggle change->form-field#validate",
      },
    )
    output = render(component)

    # Should merge with default switch controller
    assert_match(/data-controller="[^"]*switch[^"]*form-field[^"]*"/, output)
    assert_includes(output, 'data-form-field-target="toggleSwitch"')
    assert_includes(output, "form-field#validate")
  end
end

class TestSwitchThumb < ComponentTest
  def test_it_should_render_thumb_unchecked
    component = ShadcnPhlexcomponents::SwitchThumb.new(checked: false)
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="switch-thumb"')
    assert_includes(output, 'data-switch-target="thumb"')
    assert_includes(output, 'data-state="unchecked"')
    assert_match(%r{<span[^>]*></span>}, output)
  end

  def test_it_should_render_thumb_checked
    component = ShadcnPhlexcomponents::SwitchThumb.new(checked: true)
    output = render(component)

    assert_includes(output, 'data-state="checked"')
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::SwitchThumb.new(
      checked: true,
      class: "custom-thumb",
      id: "thumb-id",
    )
    output = render(component)

    # The component should render with default classes merged with custom classes
    assert_includes(output, 'id="thumb-id"')
    assert_includes(output, 'data-state="checked"')
    # NOTE: custom classes may be merged with default classes
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::SwitchThumb.new
    output = render(component)

    assert_includes(output, "bg-background")
    assert_includes(output, "dark:data-[state=unchecked]:bg-foreground")
    assert_includes(output, "dark:data-[state=checked]:bg-primary-foreground")
    assert_includes(output, "pointer-events-none block size-4 rounded-full")
    assert_includes(output, "ring-0 transition-transform")
    assert_includes(output, "data-[state=checked]:translate-x-[calc(100%-2px)]")
    assert_includes(output, "data-[state=unchecked]:translate-x-0")
  end
end

class TestSwitchWithCustomConfiguration < ComponentTest
  def test_switch_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.switch = {
      root: { base: "custom-switch-base border-2 border-blue-500" },
      thumb: { base: "custom-thumb-base bg-red-500" },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload classes
    switch_classes = ["SwitchThumb", "Switch"]

    switch_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/switch.rb", __dir__))

    # Test components with custom configuration
    switch = ShadcnPhlexcomponents::Switch.new(name: "test")
    switch_output = render(switch)
    assert_includes(switch_output, "custom-switch-base")
    assert_includes(switch_output, "border-2 border-blue-500")

    # Check that thumb also uses custom configuration
    assert_includes(switch_output, "custom-thumb-base")
    assert_includes(switch_output, "bg-red-500")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    switch_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/switch.rb", __dir__))
  end
end

class TestSwitchIntegration < ComponentTest
  def test_notification_toggle_switch
    component = ShadcnPhlexcomponents::Switch.new(
      name: "email_notifications",
      value: "enabled",
      unchecked_value: "disabled",
      checked: true,
      class: "notification-switch",
      id: "email-toggle",
      aria: {
        label: "Enable email notifications",
        describedby: "notification-help",
      },
      data: {
        controller: "switch notification-settings",
        notification_settings_target: "emailToggle",
        notification_settings_category: "email",
        action: "click->switch#toggle change->notification-settings#updatePreference",
      },
    )
    output = render(component)

    # Check notification switch structure
    assert_includes(output, "notification-switch")
    assert_includes(output, 'id="email-toggle"')
    assert_includes(output, 'aria-checked="true"')
    assert_includes(output, 'data-state="checked"')

    # Check accessibility
    assert_includes(output, 'aria-label="Enable email notifications"')
    assert_includes(output, 'aria-describedby="notification-help"')

    # Check stimulus integration
    assert_match(/data-controller="[^"]*switch[^"]*notification-settings[^"]*"/, output)
    assert_includes(output, 'data-notification-settings-target="emailToggle"')
    assert_includes(output, 'data-notification-settings-category="email"')
    assert_includes(output, "notification-settings#updatePreference")

    # Check form values
    assert_includes(output, 'name="email_notifications"')
    assert_includes(output, 'value="enabled"')
    assert_includes(output, 'value="disabled"')
    assert_includes(output, "checked")
  end

  def test_dark_mode_toggle_switch
    component = ShadcnPhlexcomponents::Switch.new(
      name: "dark_mode",
      checked: false,
      class: "theme-switch",
      aria: {
        label: "Toggle dark mode",
      },
      data: {
        controller: "switch theme-controller",
        theme_controller_target: "modeToggle",
        action: "click->switch#toggle change->theme-controller#toggleTheme",
      },
    )
    output = render(component)

    # Check theme switch
    assert_includes(output, "theme-switch")
    assert_includes(output, 'aria-checked="false"')
    assert_includes(output, 'data-state="unchecked"')
    assert_includes(output, 'aria-label="Toggle dark mode"')

    # Check controller integration
    assert_match(/data-controller="[^"]*switch[^"]*theme-controller[^"]*"/, output)
    assert_includes(output, 'data-theme-controller-target="modeToggle"')
    assert_includes(output, "theme-controller#toggleTheme")

    # Check unchecked thumb state
    assert_includes(output, 'data-state="unchecked"')
  end

  def test_privacy_settings_switch
    component = ShadcnPhlexcomponents::Switch.new(
      name: "public_profile",
      value: "public",
      unchecked_value: "private",
      checked: false,
      class: "privacy-switch",
      aria: {
        label: "Make profile public",
        describedby: "privacy-explanation",
      },
      data: {
        controller: "switch privacy-settings analytics",
        privacy_settings_target: "profileVisibility",
        analytics_category: "privacy",
        action: "click->switch#toggle change->privacy-settings#updateVisibility change->analytics#track",
      },
    )
    output = render(component)

    # Check privacy switch
    assert_includes(output, "privacy-switch")
    assert_includes(output, 'aria-checked="false"')
    assert_includes(output, 'aria-label="Make profile public"')
    assert_includes(output, 'aria-describedby="privacy-explanation"')

    # Check multiple controllers
    assert_match(/data-controller="[^"]*switch[^"]*privacy-settings[^"]*analytics[^"]*"/, output)
    assert_includes(output, 'data-privacy-settings-target="profileVisibility"')
    assert_includes(output, 'data-analytics-category="privacy"')

    # Check multiple actions
    assert_includes(output, "privacy-settings#updateVisibility")
    assert_includes(output, "analytics#track")

    # Check form values
    assert_includes(output, 'value="public"')
    assert_includes(output, 'value="private"')
  end

  def test_feature_flag_switch
    component = ShadcnPhlexcomponents::Switch.new(
      name: "experimental_features",
      checked: true,
      disabled: false,
      class: "feature-flag-switch",
      data: {
        controller: "switch feature-flags",
        feature_flags_target: "experimentalToggle",
        feature_flags_flag: "experimental_ui",
        action: "click->switch#toggle change->feature-flags#toggleFlag",
      },
    )
    output = render(component)

    # Check feature flag switch
    assert_includes(output, "feature-flag-switch")
    assert_includes(output, 'aria-checked="true"')
    assert_includes(output, 'data-state="checked"')

    # Check controller integration
    assert_match(/data-controller="[^"]*switch[^"]*feature-flags[^"]*"/, output)
    assert_includes(output, 'data-feature-flags-target="experimentalToggle"')
    assert_includes(output, 'data-feature-flags-flag="experimental_ui"')
    assert_includes(output, "feature-flags#toggleFlag")

    # Check checked state
    assert_includes(output, "checked")
    assert_includes(output, 'data-switch-is-checked-value="true"')
  end

  def test_disabled_switch
    component = ShadcnPhlexcomponents::Switch.new(
      name: "disabled_feature",
      disabled: true,
      checked: false,
      class: "disabled-switch opacity-50",
      aria: {
        label: "Feature unavailable",
        disabled: "true",
      },
    )
    output = render(component)

    # Check disabled state
    assert_includes(output, "disabled-switch opacity-50")
    assert_includes(output, "disabled")
    assert_includes(output, 'aria-disabled="true"')
    assert_includes(output, 'aria-label="Feature unavailable"')
    assert_includes(output, 'data-state="unchecked"')

    # Check disabled styling is applied
    assert_includes(output, "disabled:cursor-not-allowed disabled:opacity-50")
  end

  def test_form_integration_switch
    component = ShadcnPhlexcomponents::Switch.new(
      name: "terms_accepted",
      value: "accepted",
      unchecked_value: "not_accepted",
      checked: false,
      class: "terms-switch",
      aria: {
        label: "Accept terms and conditions",
        required: "true",
      },
      data: {
        controller: "switch form-validation",
        form_validation_target: "termsToggle",
        form_validation_required: "true",
        action: "click->switch#toggle change->form-validation#validateTerms",
      },
    )
    output = render(component)

    # Check form integration
    assert_includes(output, "terms-switch")
    assert_includes(output, 'aria-required="true"')
    assert_includes(output, 'aria-label="Accept terms and conditions"')

    # Check validation integration
    assert_match(/data-controller="[^"]*switch[^"]*form-validation[^"]*"/, output)
    assert_includes(output, 'data-form-validation-target="termsToggle"')
    assert_includes(output, 'data-form-validation-required="true"')
    assert_includes(output, "form-validation#validateTerms")

    # Check form values
    assert_includes(output, 'name="terms_accepted"')
    assert_includes(output, 'value="accepted"')
    assert_includes(output, 'value="not_accepted"')
  end

  def test_switch_accessibility_features
    component = ShadcnPhlexcomponents::Switch.new(
      name: "accessibility_test",
      checked: true,
      aria: {
        label: "High contrast mode",
        describedby: "contrast-help contrast-note",
        keyshortcuts: "Alt+C",
      },
      data: {
        controller: "switch accessibility",
        accessibility_target: "contrastToggle",
      },
    )
    output = render(component)

    # Check accessibility attributes
    assert_includes(output, 'role="switch"')
    assert_includes(output, 'aria-checked="true"')
    assert_includes(output, 'aria-label="High contrast mode"')
    assert_includes(output, 'aria-describedby="contrast-help contrast-note"')
    assert_includes(output, 'aria-keyshortcuts="Alt+C"')

    # Check controller integration
    assert_match(/data-controller="[^"]*switch[^"]*accessibility[^"]*"/, output)
    assert_includes(output, 'data-accessibility-target="contrastToggle"')
  end

  def test_switch_without_hidden_input
    component = ShadcnPhlexcomponents::Switch.new(
      name: "no_hidden_input",
      include_hidden: false,
      checked: true,
      class: "minimal-switch",
    )
    output = render(component)

    # Check no hidden input
    refute_includes(output, 'type="hidden"')

    # But checkbox should still be present
    assert_includes(output, 'type="checkbox"')
    assert_includes(output, "checked")
    assert_includes(output, 'name="no_hidden_input"')

    # Check switch functionality
    assert_includes(output, "minimal-switch")
    assert_includes(output, 'aria-checked="true"')
    assert_includes(output, 'data-state="checked"')
  end

  def test_switch_complex_workflow
    component = ShadcnPhlexcomponents::Switch.new(
      name: "marketing_consent",
      value: "granted",
      unchecked_value: "denied",
      checked: false,
      class: "consent-switch",
      aria: {
        label: "Allow marketing communications",
        describedby: "marketing-policy gdpr-notice",
      },
      data: {
        controller: "switch consent-manager analytics legal-compliance",
        consent_manager_target: "marketingToggle",
        analytics_category: "consent",
        legal_compliance_type: "marketing",
        action: "click->switch#toggle change->consent-manager#updateConsent change->analytics#trackConsent change->legal-compliance#recordConsent",
      },
    )
    output = render(component)

    # Check complex workflow structure
    assert_includes(output, "consent-switch")
    assert_includes(output, 'aria-checked="false"')
    assert_includes(output, 'aria-label="Allow marketing communications"')
    assert_includes(output, 'aria-describedby="marketing-policy gdpr-notice"')

    # Check multiple controllers
    assert_match(/data-controller="[^"]*switch[^"]*consent-manager[^"]*analytics[^"]*legal-compliance[^"]*"/, output)
    assert_includes(output, 'data-consent-manager-target="marketingToggle"')
    assert_includes(output, 'data-analytics-category="consent"')
    assert_includes(output, 'data-legal-compliance-type="marketing"')

    # Check multiple actions
    assert_includes(output, "consent-manager#updateConsent")
    assert_includes(output, "analytics#trackConsent")
    assert_includes(output, "legal-compliance#recordConsent")

    # Check form values
    assert_includes(output, 'name="marketing_consent"')
    assert_includes(output, 'value="granted"')
    assert_includes(output, 'value="denied"')
  end
end
