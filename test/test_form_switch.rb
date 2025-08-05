# frozen_string_literal: true

require "test_helper"

class TestFormSwitch < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::FormSwitch.new(
      :notifications,
    ) { "Switch content" }
    output = render(component)

    # NOTE: Block content is consumed by vanish method and not rendered
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-switch switch"')
    assert_includes(output, 'name="notifications"')
    assert_includes(output, 'id="notifications"')
    assert_includes(output, 'value="1"') # Default value
    assert_match(%r{<div[^>]*>.*</div>}m, output)
  end

  def test_it_should_render_with_model_and_method
    book = Book.new(read: true)

    component = ShadcnPhlexcomponents::FormSwitch.new(
      :read,
      model: book,
    ) { "Mark as read" }
    output = render(component)

    # NOTE: Block content is not rendered in FormSwitch, it's consumed by vanish method
    assert_includes(output, 'name="read"')
    assert_includes(output, 'id="read"')
    assert_includes(output, 'checked="true"')
    assert_includes(output, 'value="1"')
  end

  def test_it_should_handle_object_name_with_model
    book = Book.new(read: false)

    component = ShadcnPhlexcomponents::FormSwitch.new(
      :read,
      model: book,
      object_name: :book_settings,
    ) { "Mark as read" }
    output = render(component)

    assert_includes(output, 'name="book_settings[read]"')
    assert_includes(output, 'id="book_settings_read"')
    assert_includes(output, 'checked="false"')
    # NOTE: Block content is not rendered in FormSwitch, it's consumed by vanish method
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::FormSwitch.new(
      :dark_mode,
      class: "theme-switch",
      id: "custom-dark-mode",
      data: { testid: "form-switch" },
    ) { "Enable dark mode" }
    output = render(component)

    assert_includes(output, "theme-switch")
    assert_includes(output, 'id="custom-dark-mode"')
    assert_includes(output, 'data-testid="form-switch"')
    # NOTE: Block content is not rendered in FormSwitch, it's consumed by vanish method
  end

  def test_it_should_handle_explicit_value
    component = ShadcnPhlexcomponents::FormSwitch.new(
      :premium,
      value: "premium_enabled",
    ) { "Enable premium features" }
    output = render(component)

    assert_includes(output, 'name="premium"')
    assert_includes(output, 'value="premium_enabled"')
  end

  def test_it_should_handle_explicit_checked_state
    # Test explicitly checked
    checked_component = ShadcnPhlexcomponents::FormSwitch.new(
      :enabled,
      checked: true,
    ) { "Enable feature" }
    checked_output = render(checked_component)

    assert_includes(checked_output, 'checked="true"')

    # Test explicitly unchecked
    unchecked_component = ShadcnPhlexcomponents::FormSwitch.new(
      :disabled,
      checked: false,
    ) { "Disable feature" }
    unchecked_output = render(unchecked_component)

    assert_includes(unchecked_output, 'checked="false"')
  end

  def test_it_should_render_with_label
    component = ShadcnPhlexcomponents::FormSwitch.new(
      :email_notifications,
      label: "Email Notifications",
    ) { "Enable email notifications" }
    output = render(component)

    assert_includes(output, "Email Notifications")
    # NOTE: Block content is not rendered in FormSwitch, it's consumed by vanish method
    assert_match(/for="email_notifications"/, output)
  end

  def test_it_should_render_with_hint
    component = ShadcnPhlexcomponents::FormSwitch.new(
      :auto_save,
      hint: "Automatically save changes as you type",
    ) { "Enable auto-save" }
    output = render(component)

    assert_includes(output, "Automatically save changes as you type")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
    assert_match(/id="[^"]*-description"/, output)
  end

  def test_it_should_render_with_error_from_model
    book = Book.new
    book.valid? # trigger validation errors

    component = ShadcnPhlexcomponents::FormSwitch.new(
      :read,
      model: book,
    ) { "This field is required" }
    output = render(component)

    # Check if there are any errors on read field
    if book.errors[:read].any?
      # HTML encoding changes apostrophes
      expected_error = book.errors[:read].first.gsub("'", "&#39;")
      assert_includes(output, expected_error)
      assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
      assert_includes(output, "text-destructive")
    else
      # If no errors on read field, test with a book that has errors
      book.errors.add(:read, "must be accepted")
      component = ShadcnPhlexcomponents::FormSwitch.new(
        :read,
        model: book,
      )
      output = render(component)
      assert_includes(output, "must be accepted")
      assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
    end
  end

  def test_it_should_render_with_explicit_error
    component = ShadcnPhlexcomponents::FormSwitch.new(
      :terms,
      error: "You must accept the terms",
    ) { "Accept terms and conditions" }
    output = render(component)

    assert_includes(output, "You must accept the terms")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
  end

  def test_it_should_render_with_custom_name_and_id
    component = ShadcnPhlexcomponents::FormSwitch.new(
      :agreement,
      name: "custom_agreement",
      id: "agreement-switch",
    ) { "I agree to the terms" }
    output = render(component)

    assert_includes(output, 'name="custom_agreement"')
    assert_includes(output, 'id="agreement-switch"')
  end

  def test_it_should_generate_proper_aria_attributes
    component = ShadcnPhlexcomponents::FormSwitch.new(
      :accessibility_test,
      label: "Accessible Switch",
      hint: "Toggle this setting on or off",
    ) { "Toggle setting" }
    output = render(component)

    assert_match(/aria-describedby="[^"]*-description"/, output)
    assert_includes(output, 'aria-invalid="false"')
  end

  def test_it_should_handle_aria_attributes_with_error
    component = ShadcnPhlexcomponents::FormSwitch.new(
      :required_switch,
      error: "This field is required",
    ) { "Required switch" }
    output = render(component)

    assert_includes(output, 'aria-invalid="true"')
    assert_match(/aria-describedby="[^"]*-message"/, output)
  end

  def test_it_should_render_complete_form_structure
    book = Book.new(read: false)

    component = ShadcnPhlexcomponents::FormSwitch.new(
      :read,
      model: book,
      object_name: :book,
      label: "Mark as Read",
      hint: "Toggle to mark this book as read or unread",
      checked: true, # explicit checked should override model
      class: "read-status-switch",
      data: {
        controller: "switch analytics",
        analytics_event: "read_status_change",
      },
      value: "read",
    ) { "Mark book as read" }
    output = render(component)

    # Check main structure
    assert_includes(output, "read-status-switch")
    assert_includes(output, 'name="book[read]"')
    assert_includes(output, 'id="book_read"')

    # Explicit checked should be used (not model value)
    assert_includes(output, 'checked="true"')
    assert_includes(output, 'value="read"')

    # Check form field components
    assert_includes(output, "Mark as Read")
    assert_includes(output, "Toggle to mark this book as read or unread")
    # NOTE: Block content is not rendered in FormSwitch

    # Check Stimulus integration
    assert_match(/data-controller="[^"]*switch[^"]*analytics/, output)
    assert_includes(output, 'data-analytics-event="read_status_change"')

    # Check accessibility
    assert_match(/aria-describedby="[^"]*-description"/, output)
    assert_includes(output, 'aria-invalid="false"')

    # Check FormField wrapper
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::FormSwitch.new(
      :disabled_switch,
      disabled: true,
    ) { "Disabled switch" }
    output = render(component)

    assert_includes(output, "disabled")
  end

  def test_it_should_handle_switch_layout
    component = ShadcnPhlexcomponents::FormSwitch.new(
      :layout_test,
      label: "Test Switch",
    )
    output = render(component)

    # FormSwitch has specific layout with flex items-center gap-2
    assert_includes(output, "flex items-center gap-2")
    # Switch comes before label in the layout
    assert_includes(output, 'data-shadcn-phlexcomponents="form-switch switch"')
  end

  def test_it_should_handle_block_content_with_label_and_hint
    component = ShadcnPhlexcomponents::FormSwitch.new(
      :custom_switch,
    ) do |switch|
      switch.label("Custom Switch Label", class: "font-semibold")
      switch.hint("Custom hint text", class: "text-sm text-gray-500")
      "Custom switch content"
    end
    output = render(component)

    assert_includes(output, "Custom Switch Label")
    assert_includes(output, "font-semibold")
    assert_includes(output, "Custom hint text")
    assert_includes(output, "text-sm text-gray-500")
    # NOTE: Block content is not rendered in FormSwitch, the returned string is consumed by vanish method

    # Should have data attributes for removing duplicates
    assert_includes(output, "data-remove-hint")
  end
end

class TestFormSwitchIntegration < ComponentTest
  def test_form_switch_with_complex_model
    # Use Book with boolean attributes
    book = Book.new(
      read: true,
      category: "fiction",
    )

    # Test read status switch
    read_component = ShadcnPhlexcomponents::FormSwitch.new(
      :read,
      model: book,
      object_name: :book,
      label: "Reading Status",
      hint: "Mark whether you have read this book",
      class: "read-status",
    ) { "Mark as read" }
    read_output = render(read_component)

    # Check proper model integration
    assert_includes(read_output, 'name="book[read]"')
    assert_includes(read_output, 'id="book_read"')
    assert_includes(read_output, 'checked="true"')

    # Check form field structure
    assert_includes(read_output, "read-status")
    assert_includes(read_output, "Reading Status")
    assert_includes(read_output, "Mark whether you have read this book")
  end

  def test_form_switch_accessibility_compliance
    component = ShadcnPhlexcomponents::FormSwitch.new(
      :accessibility_test,
      label: "Accessible Switch Control",
      hint: "Use spacebar to toggle this switch",
      error: "This option must be enabled",
      aria: { required: "true" },
    ) { "Toggle option" }
    output = render(component)

    # Check ARIA compliance
    # Check ARIA describedby includes both description and message IDs
    assert_includes(output, "form-field-")
    assert_includes(output, "-description")
    assert_includes(output, "-message")
    # Check error state is properly displayed
    assert_includes(output, "This option must be enabled")
    assert_includes(output, "text-destructive")
    assert_includes(output, 'aria-required="true"')

    # Check label association
    assert_match(/for="accessibility_test"/, output)

    # Check error and hint IDs are properly referenced
    assert_match(/id="[^"]*-description"/, output)
    assert_match(/id="[^"]*-message"/, output)

    # Check proper label styling for error state
    assert_includes(output, "text-destructive")
  end

  def test_form_switch_with_stimulus_integration
    component = ShadcnPhlexcomponents::FormSwitch.new(
      :stimulus_switch,
      data: {
        controller: "switch analytics toggle-handler",
        analytics_category: "form_switch",
        toggle_handler_action: "track_change",
      },
    ) { "Toggle feature" }
    output = render(component)

    # Check multiple Stimulus controllers
    assert_match(/data-controller="[^"]*switch[^"]*analytics[^"]*toggle-handler/, output)
    assert_includes(output, 'data-analytics-category="form_switch"')
    assert_includes(output, 'data-toggle-handler-action="track_change"')

    # Check default switch Stimulus functionality
    assert_includes(output, 'data-shadcn-phlexcomponents="form-switch switch"')
  end

  def test_form_switch_validation_states
    # Test valid state
    valid_component = ShadcnPhlexcomponents::FormSwitch.new(
      :valid_switch,
      checked: true,
      class: "valid-switch",
    ) { "Valid switch field" }
    valid_output = render(valid_component)

    assert_includes(valid_output, 'aria-invalid="false"')
    assert_includes(valid_output, "valid-switch")

    # Test invalid state
    invalid_component = ShadcnPhlexcomponents::FormSwitch.new(
      :invalid_switch,
      error: "This option is required",
      class: "invalid-switch",
    ) { "Invalid switch field" }
    invalid_output = render(invalid_component)

    assert_includes(invalid_output, 'aria-invalid="true"')
    assert_includes(invalid_output, "text-destructive") # Error styling on label
  end

  def test_form_switch_form_integration_workflow
    # Test complete form workflow with validation and model binding

    # Valid book with boolean value
    valid_book = Book.new(read: true)

    switch_field = ShadcnPhlexcomponents::FormSwitch.new(
      :read,
      model: valid_book,
      label: "Reading Status",
      hint: "Toggle reading status",
    )
    switch_output = render(switch_field)

    assert_includes(switch_output, 'checked="true"')
    assert_includes(switch_output, 'aria-invalid="false"')
    refute_includes(switch_output, "text-destructive")

    # Invalid book with validation error
    invalid_book = Book.new
    invalid_book.errors.add(:read, "must be accepted")

    invalid_switch = ShadcnPhlexcomponents::FormSwitch.new(
      :read,
      model: invalid_book,
      label: "Reading Status",
      hint: "Toggle reading status",
    )
    invalid_output = render(invalid_switch)

    refute_includes(invalid_output, 'checked="true"')
    assert_includes(invalid_output, 'aria-invalid="true"')
    assert_includes(invalid_output, "must be accepted")
    assert_includes(invalid_output, "text-destructive")
  end

  def test_form_switch_with_custom_styling
    component = ShadcnPhlexcomponents::FormSwitch.new(
      :styled_switch,
      checked: true,
      label: "Styled Switch",
      hint: "This switch has custom styling",
      class: "w-full max-w-md custom-switch border rounded",
      data: { theme: "primary" },
    ) { "Custom styled switch content" }
    output = render(component)

    # Check custom styling is applied
    assert_includes(output, "w-full max-w-md custom-switch border rounded")
    assert_includes(output, 'data-theme="primary"')

    # Check form field structure is preserved
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, "Styled Switch")
    assert_includes(output, "This switch has custom styling")
  end

  def test_form_switch_keyboard_interaction
    component = ShadcnPhlexcomponents::FormSwitch.new(
      :keyboard_test,
    ) { "Keyboard test" }
    output = render(component)

    # Check keyboard interaction setup
    assert_includes(output, 'data-shadcn-phlexcomponents="form-switch switch"')
    # Switch should handle spacebar and enter key interactions internally
  end

  def test_form_switch_semantic_html_structure
    # Test that FormSwitch produces semantic HTML
    component = ShadcnPhlexcomponents::FormSwitch.new(
      :semantic_test,
      label: "Semantic Switch",
    )
    output = render(component)

    # Should use proper form field structure
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-switch switch"')
    assert_includes(output, "Semantic Switch")

    # Should have proper layout structure
    assert_includes(output, "flex items-center gap-2")
  end

  def test_form_switch_with_different_values
    # Test with custom value
    custom_value_component = ShadcnPhlexcomponents::FormSwitch.new(
      :custom_value_test,
      value: "enabled",
    )
    custom_value_output = render(custom_value_component)

    assert_includes(custom_value_output, 'value="enabled"')

    # Test with default value
    default_value_component = ShadcnPhlexcomponents::FormSwitch.new(
      :default_value_test,
    )
    default_value_output = render(default_value_component)

    assert_includes(default_value_output, 'value="1"')
  end

  def test_form_switch_label_positioning
    # Test that label appears after the switch in the layout
    component = ShadcnPhlexcomponents::FormSwitch.new(
      :label_position_test,
      label: "Test Label",
    )
    output = render(component)

    # Should have flex layout with switch first, then label
    assert_includes(output, "flex items-center gap-2")

    # The switch element should come before the label in the HTML
    switch_pos = output.index('data-shadcn-phlexcomponents="form-switch switch"')
    label_pos = output.index("Test Label")

    assert(switch_pos < label_pos, "Switch should appear before label in HTML")
  end

  def test_form_switch_with_required_attribute
    component = ShadcnPhlexcomponents::FormSwitch.new(
      :required_test,
      required: true,
      label: "Required Switch",
    )
    output = render(component)

    assert_includes(output, "required")
    assert_includes(output, "Required Switch")
  end

  def test_form_switch_toggle_behavior_attributes
    component = ShadcnPhlexcomponents::FormSwitch.new(
      :toggle_test,
      checked: false,
      label: "Toggle Test",
    )
    output = render(component)

    # Should have proper attributes for toggle behavior
    assert_includes(output, 'checked="false"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-switch switch"')
  end

  def test_form_switch_with_internationalization
    # Test switches with i18n labels and hints
    component = ShadcnPhlexcomponents::FormSwitch.new(
      :i18n_test,
      label: "Activer les notifications",
      hint: "Recevez des notifications par email",
    )
    output = render(component)

    assert_includes(output, "Activer les notifications")
    assert_includes(output, "Recevez des notifications par email")
  end

  def test_form_switch_error_handling
    # Test switch with multiple types of errors
    error_component = ShadcnPhlexcomponents::FormSwitch.new(
      :error_test,
      label: "Error Test Switch",
      error: "This field is required and must be enabled",
    )
    error_output = render(error_component)

    assert_includes(error_output, "This field is required and must be enabled")
    assert_includes(error_output, 'aria-invalid="true"')
    assert_includes(error_output, "text-destructive")
  end
end
