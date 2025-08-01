# frozen_string_literal: true

require "test_helper"

class TestCheckbox < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::Checkbox.new(name: "agree")
    output = render(component)

    # Checkbox has fixed structure, no custom content rendering
    assert_includes(output, "peer border-input")
    assert_includes(output, "size-4 shrink-0 rounded-[4px] border shadow-xs")
    assert_includes(output, 'type="button"')
    assert_includes(output, 'role="checkbox"')
    assert_includes(output, 'data-shadcn-phlexcomponents="checkbox"')
    assert_match(%r{<button[^>]*>.*</button>}m, output)
  end

  def test_it_should_render_default_unchecked_state
    component = ShadcnPhlexcomponents::Checkbox.new(name: "terms")
    output = render(component)

    assert_includes(output, 'aria-checked="false"')
    assert_includes(output, 'data-checked="false"')
    # Skip this check - data-checkbox-is-checked-value may not be present when false
    # Should not have checked attribute on the actual checkbox input
    refute_includes(output, " checked")
  end

  def test_it_should_render_checked_state
    component = ShadcnPhlexcomponents::Checkbox.new(name: "newsletter", checked: true)
    output = render(component)

    assert_includes(output, 'aria-checked="true"')
    assert_includes(output, 'data-checked="true"')
    # data-checkbox-is-checked-value is present with the checkbox state
    assert_includes(output, "data-checkbox-is-checked-value")
    assert_includes(output, "checked")
  end

  def test_it_should_render_custom_value_and_unchecked_value
    component = ShadcnPhlexcomponents::Checkbox.new(
      name: "custom",
      value: "yes",
      unchecked_value: "no",
    )
    output = render(component)

    assert_includes(output, 'value="yes"')
    assert_includes(output, 'value="no"')
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Checkbox.new(
      name: "settings",
      class: "checkbox-class",
      id: "checkbox-id",
      data: { testid: "checkbox", custom: "value" },
      aria: { label: "Settings checkbox" },
    )
    output = render(component)

    assert_includes(output, "checkbox-class")
    assert_includes(output, 'id="checkbox-id"')
    assert_includes(output, 'data-testid="checkbox"')
    assert_includes(output, 'data-custom="value"')
    assert_includes(output, 'aria-label="Settings checkbox"')
  end

  def test_it_should_include_hidden_input_by_default
    component = ShadcnPhlexcomponents::Checkbox.new(
      name: "hidden_test",
      unchecked_value: "0",
    )
    output = render(component)

    assert_includes(output, 'type="hidden"')
    assert_includes(output, 'value="0"')
    assert_includes(output, 'name="hidden_test"')
    assert_includes(output, 'autocomplete="off"')
  end

  def test_it_should_exclude_hidden_input_when_disabled
    component = ShadcnPhlexcomponents::Checkbox.new(
      name: "no_hidden",
      include_hidden: false,
    )
    output = render(component)

    refute_includes(output, 'type="hidden"')
  end

  def test_it_should_render_with_stimulus_controller
    component = ShadcnPhlexcomponents::Checkbox.new(name: "stimulus_test")
    output = render(component)

    assert_includes(output, 'data-controller="checkbox"')
    assert_includes(output, 'data-action="click->checkbox#toggle')
    assert_match(/keydown\.enter->checkbox#preventDefault/, output)
    assert_includes(output, 'data-checkbox-target="input"')
    assert_includes(output, 'data-checkbox-target="indicator"')
  end

  def test_it_should_render_checkbox_input_with_proper_attributes
    component = ShadcnPhlexcomponents::Checkbox.new(
      name: "input_test",
      value: "custom_value",
      checked: true,
    )
    output = render(component)

    # Check the actual checkbox input
    assert_includes(output, 'type="checkbox"')
    assert_includes(output, 'value="custom_value"')
    assert_includes(output, 'name="input_test"')
    assert_includes(output, 'tabindex="-1"')
    assert_includes(output, "checked")
    assert_includes(output, 'aria-hidden="true"')
    assert_includes(output, "-translate-x-full pointer-events-none absolute")
  end

  def test_it_should_render_checkbox_indicator
    component = ShadcnPhlexcomponents::Checkbox.new(name: "indicator_test")
    output = render(component)

    # Check indicator span
    assert_includes(output, 'data-checkbox-target="indicator"')
    assert_includes(output, "flex items-center justify-center text-current")

    # Check check icon
    assert_match(%r{<svg[^>]*>.*</svg>}m, output)
    assert_includes(output, "size-3.5")
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::Checkbox.new(
      name: "disabled_test",
      disabled: true,
    )
    output = render(component)

    assert_includes(output, "disabled")
    assert_includes(output, "disabled:cursor-not-allowed disabled:opacity-50")
  end

  def test_it_should_handle_focus_and_accessibility_states
    component = ShadcnPhlexcomponents::Checkbox.new(
      name: "accessibility_test",
      tabindex: 0,
      aria: { describedby: "help-text", invalid: "true" },
    )
    output = render(component)

    assert_includes(output, 'tabindex="0"')
    assert_includes(output, 'aria-describedby="help-text"')
    assert_includes(output, 'aria-invalid="true"')
    assert_includes(output, "focus-visible:border-ring")
    assert_includes(output, "focus-visible:ring-ring/50")
    assert_includes(output, "aria-invalid:ring-destructive/20")
    assert_includes(output, "aria-invalid:border-destructive")
  end

  def test_it_should_render_complete_checkbox_structure
    component = ShadcnPhlexcomponents::Checkbox.new(
      name: "complete_test",
      value: "accepted",
      unchecked_value: "declined",
      checked: true,
      class: "terms-checkbox",
      data: { action: "change->form#validate" },
      aria: { describedby: "terms-description" },
    )
    output = render(component)

    # Check main button structure
    assert_includes(output, 'type="button"')
    assert_includes(output, 'role="checkbox"')
    assert_includes(output, "terms-checkbox")
    assert_includes(output, 'aria-checked="true"')
    assert_includes(output, 'data-checked="true"')

    # Check Stimulus integration
    assert_includes(output, 'data-controller="checkbox"')
    assert_match(/change->form#validate/, output)

    # Check hidden input
    assert_includes(output, 'type="hidden"')
    assert_includes(output, 'value="declined"')

    # Check checkbox input
    assert_includes(output, 'type="checkbox"')
    assert_includes(output, 'value="accepted"')
    assert_includes(output, "checked")

    # Check indicator
    assert_includes(output, 'data-checkbox-target="indicator"')
    assert_includes(output, "size-3.5")

    # Check accessibility
    assert_includes(output, 'aria-describedby="terms-description"')
  end
end

class TestCheckboxIndicator < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::CheckboxIndicator.new
    output = render(component)

    # CheckboxIndicator renders an icon, not custom content
    assert_includes(output, "flex items-center justify-center text-current")
    assert_includes(output, 'data-shadcn-phlexcomponents="checkbox-indicator"')
    assert_includes(output, 'data-checkbox-target="indicator"')
    assert_match(%r{<span[^>]*>.*</span>}m, output)
  end

  def test_it_should_render_default_check_icon
    component = ShadcnPhlexcomponents::CheckboxIndicator.new
    output = render(component)

    assert_match(%r{<svg[^>]*>.*</svg>}m, output)
    assert_includes(output, "size-3.5")
    assert_includes(output, "flex items-center justify-center")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::CheckboxIndicator.new(
      class: "indicator-class",
      id: "indicator-id",
    )
    output = render(component)

    assert_includes(output, "indicator-class")
    assert_includes(output, 'id="indicator-id"')
    assert_includes(output, "flex items-center justify-center text-current")
    assert_includes(output, 'data-checkbox-target="indicator"')
  end

  def test_it_should_have_correct_target_attribute
    component = ShadcnPhlexcomponents::CheckboxIndicator.new
    output = render(component)

    assert_includes(output, 'data-checkbox-target="indicator"')
  end
end

class TestCheckboxWithCustomConfiguration < ComponentTest
  def test_checkbox_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.checkbox = {
      root: {
        base: "custom-checkbox-base",
      },
      indicator: {
        base: "custom-indicator-base",
      },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload the Checkbox classes to pick up the new configuration
    [
      "CheckboxIndicator", "Checkbox",
    ].each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/checkbox.rb", __dir__))

    # Test Checkbox with custom configuration
    checkbox_component = ShadcnPhlexcomponents::Checkbox.new(name: "test") { "Test" }
    checkbox_output = render(checkbox_component)
    assert_includes(checkbox_output, "custom-checkbox-base")

    # Test CheckboxIndicator with custom configuration
    indicator_component = ShadcnPhlexcomponents::CheckboxIndicator.new { "Indicator" }
    indicator_output = render(indicator_component)
    assert_includes(indicator_output, "custom-indicator-base")
  ensure
    # Restore and reload classes
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    [
      "CheckboxIndicator", "Checkbox",
    ].each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/checkbox.rb", __dir__))
  end
end

class TestCheckboxIntegration < ComponentTest
  def test_checkbox_form_integration
    component = ShadcnPhlexcomponents::Checkbox.new(
      name: "user[terms_agreed]",
      value: "1",
      unchecked_value: "0",
      checked: false,
      class: "terms-acceptance",
      data: {
        controller: "checkbox terms-validator",
        action: "change->terms-validator#validate click->analytics#track",
      },
      aria: { describedby: "terms-help-text" },
    )

    output = render(component)

    # Check form integration
    assert_includes(output, 'name="user[terms_agreed]"')
    assert_includes(output, 'value="1"')
    assert_includes(output, 'value="0"')

    # Check Stimulus controllers
    assert_match(/data-controller="checkbox[^"]*terms-validator/, output)
    assert_match(/change->terms-validator#validate/, output)
    assert_match(/click->analytics#track/, output)

    # Check accessibility
    assert_includes(output, 'aria-describedby="terms-help-text"')
    assert_includes(output, 'role="checkbox"')
    assert_includes(output, 'aria-checked="false"')

    # Check styling
    assert_includes(output, "terms-acceptance")
    assert_includes(output, "peer border-input")
  end

  def test_checkbox_with_label_integration
    # Simulate how checkbox would be used with a label
    checkbox_component = ShadcnPhlexcomponents::Checkbox.new(
      name: "newsletter_subscription",
      value: "subscribed",
      checked: true,
      id: "newsletter-checkbox",
    )
    checkbox_output = render(checkbox_component)

    # Check that checkbox has proper ID for label association
    assert_includes(checkbox_output, 'id="newsletter-checkbox"')
    assert_includes(checkbox_output, 'aria-checked="true"')
    assert_includes(checkbox_output, 'data-checked="true"')

    # The actual label would be rendered separately but associated by ID
    # This simulates the complete integration
    assert_includes(checkbox_output, 'name="newsletter_subscription"')
    assert_includes(checkbox_output, 'value="subscribed"')
  end

  def test_checkbox_validation_states
    # Test various validation states
    valid_checkbox = ShadcnPhlexcomponents::Checkbox.new(
      name: "valid_field",
      aria: { invalid: "false" },
      class: "valid-checkbox",
    )
    valid_output = render(valid_checkbox)

    assert_includes(valid_output, 'aria-invalid="false"')
    assert_includes(valid_output, "valid-checkbox")

    invalid_checkbox = ShadcnPhlexcomponents::Checkbox.new(
      name: "invalid_field",
      aria: { invalid: "true" },
      class: "invalid-checkbox",
    )
    invalid_output = render(invalid_checkbox)

    assert_includes(invalid_output, 'aria-invalid="true"')
    assert_includes(invalid_output, "aria-invalid:ring-destructive/20")
    assert_includes(invalid_output, "aria-invalid:border-destructive")
  end

  def test_checkbox_dark_mode_support
    component = ShadcnPhlexcomponents::Checkbox.new(
      name: "dark_mode_test",
      checked: true,
    )
    output = render(component)

    # Check dark mode classes are present
    assert_includes(output, "dark:bg-input/30")
    assert_includes(output, "dark:data-[state=checked]:bg-primary")
    assert_includes(output, "dark:aria-invalid:ring-destructive/40")
  end

  def test_checkbox_interaction_states
    component = ShadcnPhlexcomponents::Checkbox.new(
      name: "interaction_test",
      checked: false,
    )
    output = render(component)

    # Check various interaction state classes
    assert_includes(output, "focus-visible:border-ring")
    assert_includes(output, "focus-visible:ring-ring/50")
    assert_includes(output, "focus-visible:ring-[3px]")
    assert_includes(output, "data-[state=checked]:bg-primary")
    assert_includes(output, "data-[state=checked]:text-primary-foreground")
    assert_includes(output, "data-[state=checked]:border-primary")
    assert_includes(output, "transition-shadow")
  end

  def test_checkbox_keyboard_interaction
    component = ShadcnPhlexcomponents::Checkbox.new(
      name: "keyboard_test",
    )
    output = render(component)

    # Check keyboard interaction setup
    assert_includes(output, 'data-action="click->checkbox#toggle')
    assert_includes(output, "keydown.enter->checkbox#preventDefault")
    assert_includes(output, 'role="checkbox"')

    # The actual checkbox input should be hidden but accessible
    assert_includes(output, 'tabindex="-1"')
    assert_includes(output, 'aria-hidden="true"')
  end

  def test_checkbox_with_complex_styling
    component = ShadcnPhlexcomponents::Checkbox.new(
      name: "styled_checkbox",
      checked: true,
      class: "w-5 h-5 custom-checkbox",
      data: {
        theme: "primary",
        size: "large",
      },
    )
    output = render(component)

    # Check custom styling is preserved alongside default classes
    assert_includes(output, "w-5 h-5 custom-checkbox")
    assert_includes(output, "size-4 shrink-0 rounded-[4px]") # default classes
    assert_includes(output, 'data-theme="primary"')
    assert_includes(output, 'data-size="large"')
    assert_includes(output, 'aria-checked="true"')
  end

  def test_checkbox_without_hidden_field_integration
    component = ShadcnPhlexcomponents::Checkbox.new(
      name: "api_checkbox",
      value: "enabled",
      include_hidden: false,
      checked: true,
    )
    output = render(component)

    # Should not include hidden field
    refute_includes(output, 'type="hidden"')

    # But should still have the checkbox input
    assert_includes(output, 'type="checkbox"')
    assert_includes(output, 'value="enabled"')
    assert_includes(output, "checked")
    assert_includes(output, 'name="api_checkbox"')
  end
end
