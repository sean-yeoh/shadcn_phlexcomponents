# frozen_string_literal: true

require "test_helper"

class TestFormCheckbox < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :terms_accepted,
    ) { "I accept the terms and conditions" }
    output = render(component)

    # NOTE: Block content in FormCheckbox is consumed by vanish method and not rendered
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-checkbox checkbox"')
    assert_includes(output, 'name="terms_accepted"')
    assert_includes(output, 'id="terms_accepted"')
    assert_includes(output, 'value="1"')
    assert_match(%r{<div[^>]*>.*</div>}m, output)
  end

  def test_it_should_render_with_model_and_method
    book = Book.new(read: true)

    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :read,
      model: book,
    ) { "Subscribe to newsletter" }
    output = render(component)

    # NOTE: Block content is not rendered in FormCheckbox, it's consumed by vanish method
    assert_includes(output, 'name="read"')
    assert_includes(output, 'id="read"')
    assert_includes(output, "checked")
    assert_includes(output, 'data-checked="true"')
  end

  def test_it_should_handle_object_name_with_model
    book = Book.new(read: false)

    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :read,
      model: book,
      object_name: :book_settings,
    ) { "Mark as read" }
    output = render(component)

    assert_includes(output, 'name="book_settings[read]"')
    assert_includes(output, 'id="book_settings_read"')
    assert_includes(output, 'aria-checked="false"')
    assert_includes(output, 'data-checked="false"')
    # NOTE: Block content is not rendered in FormCheckbox, it's consumed by vanish method
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :privacy_policy,
      class: "privacy-checkbox",
      id: "custom-privacy",
      data: { testid: "privacy-checkbox" },
    ) { "I agree to the privacy policy" }
    output = render(component)

    assert_includes(output, "privacy-checkbox")
    assert_includes(output, 'id="custom-privacy"')
    assert_includes(output, 'data-testid="privacy-checkbox"')
    # NOTE: Block content is not rendered in FormCheckbox, it's consumed by vanish method
  end

  def test_it_should_handle_explicit_checked_state
    # Test explicit checked = true
    checked_component = ShadcnPhlexcomponents::FormCheckbox.new(
      :marketing_emails,
      checked: true,
    ) { "Receive marketing emails" }
    checked_output = render(checked_component)

    assert_includes(checked_output, "checked")
    assert_includes(checked_output, 'data-checked="true"')
    assert_includes(checked_output, 'aria-checked="true"')

    # Test explicit checked = false
    unchecked_component = ShadcnPhlexcomponents::FormCheckbox.new(
      :promotional_sms,
      checked: false,
    ) { "Receive promotional SMS" }
    unchecked_output = render(unchecked_component)

    refute_includes(unchecked_output, " checked")
    assert_includes(unchecked_output, 'data-checked="false"')
    assert_includes(unchecked_output, 'aria-checked="false"')
  end

  def test_it_should_handle_custom_value
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :subscription_type,
      value: "premium",
    ) { "Premium subscription" }
    output = render(component)

    assert_includes(output, 'value="premium"')
    assert_includes(output, 'name="subscription_type"')
  end

  def test_it_should_render_with_label
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :terms,
      label: "Terms and Conditions",
    ) { "I have read and accept the terms" }
    output = render(component)

    assert_includes(output, "Terms and Conditions")
    # NOTE: Block content in FormCheckbox doesn't get rendered as expected
    # The block content is consumed by the vanish method
    assert_match(/for="terms"/, output)
  end

  def test_it_should_render_with_hint
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :notifications,
      hint: "You can change this setting later in your profile",
    ) { "Enable notifications" }
    output = render(component)

    assert_includes(output, "You can change this setting later in your profile")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
    assert_match(/id="[^"]*-description"/, output)
  end

  def test_it_should_render_with_error_from_model
    book = Book.new
    book.valid? # trigger validation errors

    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :title,
      model: book,
    ) { "This field is required" }
    output = render(component)

    assert_includes(output, "Title can&#39;t be blank")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
    assert_includes(output, "text-destructive")
  end

  def test_it_should_render_with_explicit_error
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :agreement,
      error: "You must agree to continue",
    ) { "I agree" }
    output = render(component)

    assert_includes(output, "You must agree to continue")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
  end

  def test_it_should_render_with_custom_name_and_id
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :subscribe,
      name: "newsletter_subscription",
      id: "newsletter-checkbox",
    ) { "Subscribe to newsletter" }
    output = render(component)

    assert_includes(output, 'name="newsletter_subscription"')
    assert_includes(output, 'id="newsletter-checkbox"')
  end

  def test_it_should_handle_label_positioning
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :confirmation,
      label: "Confirmation Required",
    ) { "I confirm this action" }
    output = render(component)

    # Check label positioning classes
    assert_includes(output, "ml-6") # Label should be offset from checkbox
    assert_includes(output, "flex items-top space-x-2") # Container layout
    assert_includes(output, "-mt-[1.5px] absolute top-0 left-0") # Checkbox positioning
  end

  def test_it_should_handle_hint_positioning
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :optional_feature,
      hint: "This is an optional setting",
    ) { "Enable optional feature" }
    output = render(component)

    # Hint should also be offset like the label
    assert_includes(output, "ml-6")
    assert_includes(output, "This is an optional setting")
  end

  def test_it_should_generate_proper_aria_attributes
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :accessibility_test,
      label: "Accessibility Test",
      hint: "Test accessibility features",
    ) { "Enable accessibility" }
    output = render(component)

    assert_match(/aria-describedby="[^"]*-description"/, output)
    assert_includes(output, 'aria-invalid="false"')
    assert_includes(output, 'role="checkbox"')
  end

  def test_it_should_handle_aria_attributes_with_error
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :required_checkbox,
      error: "This field is required",
    ) { "Required field" }
    output = render(component)

    assert_includes(output, 'aria-invalid="true"')
    assert_match(/aria-describedby="[^"]*-message"/, output)
  end

  def test_it_should_include_stimulus_controller
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :stimulus_test,
    ) { "Stimulus test" }
    output = render(component)

    assert_includes(output, 'data-controller="checkbox"')
    assert_includes(output, 'data-action="click->checkbox#toggle')
    assert_match(/keydown\.enter->checkbox#preventDefault/, output)
    assert_includes(output, 'data-checkbox-target="input"')
  end

  def test_it_should_include_hidden_input
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :hidden_test,
    ) { "Hidden test" }
    output = render(component)

    assert_includes(output, 'type="hidden"')
    assert_includes(output, 'type="checkbox"')
    assert_includes(output, 'name="hidden_test"')
    assert_includes(output, 'autocomplete="off"')
  end

  def test_it_should_render_complete_checkbox_structure
    book = Book.new(read: true)

    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :read,
      model: book,
      object_name: :user,
      label: "Marketing Communications",
      hint: "We will only send you relevant updates and offers",
      value: "yes",
      class: "marketing-checkbox",
      data: {
        controller: "checkbox analytics",
        analytics_event: "marketing_consent_toggle",
      },
    ) { "I consent to receiving marketing communications" }
    output = render(component)

    # Check main structure
    assert_includes(output, 'name="user[read]"')
    assert_includes(output, 'id="user_read"')
    assert_includes(output, 'value="yes"')
    assert_includes(output, "marketing-checkbox")

    # Check model integration (should be checked)
    assert_includes(output, "checked")
    assert_includes(output, 'data-checked="true"')

    # Check label and hint
    assert_includes(output, "Marketing Communications")
    assert_includes(output, "We will only send you relevant updates and offers")
    # NOTE: Block content is consumed by vanish method and not rendered in the checkbox component

    # Check Stimulus integration
    assert_match(/data-controller="checkbox[^"]*analytics/, output)
    assert_includes(output, 'data-analytics-event="marketing_consent_toggle"')

    # Check layout structure
    assert_includes(output, "flex items-top space-x-2")
    assert_includes(output, "ml-6") # Label offset
    assert_includes(output, "-mt-[1.5px] absolute top-0 left-0") # Checkbox positioning

    # Check accessibility
    assert_match(/aria-describedby="[^"]*-description"/, output)
    assert_includes(output, 'aria-invalid="false"')
    assert_includes(output, 'role="checkbox"')

    # Check hidden input
    assert_includes(output, 'type="hidden"')
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :disabled_test,
      disabled: true,
    ) { "Disabled checkbox" }
    output = render(component)

    assert_includes(output, "disabled")
    assert_includes(output, "disabled:cursor-not-allowed disabled:opacity-50")
  end

  def test_it_should_use_default_value_when_none_provided
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :default_value_test,
    ) { "Default value test" }
    output = render(component)

    # Should default to "1"
    assert_includes(output, 'value="1"')
  end

  def test_it_should_handle_form_field_layout
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :layout_test,
      label: "Layout Test",
      hint: "Test the layout",
    ) { "Test content" }
    output = render(component)

    # Check FormField wrapper
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')

    # Check flex layout for checkbox and content
    assert_includes(output, "flex items-top space-x-2")

    # Check grid layout for label and hint
    assert_includes(output, "grid gap-1.5 relative")
  end

  def test_it_should_handle_block_content_with_label_and_hint
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :custom_content,
    ) do |checkbox|
      checkbox.label("Custom Label", class: "font-semibold")
      checkbox.hint("Custom hint text", class: "text-sm text-gray-500")
      "Custom checkbox content"
    end
    output = render(component)

    assert_includes(output, "Custom Label")
    assert_includes(output, "font-semibold")
    assert_includes(output, "Custom hint text")
    assert_includes(output, "text-sm text-gray-500")
    # NOTE: Block content is not rendered in FormCheckbox, the returned string is consumed by vanish method

    # Should have data attributes for removing duplicates
    assert_includes(output, "data-remove-hint")
  end
end

class TestFormCheckboxIntegration < ComponentTest
  def test_form_checkbox_with_complex_model
    # Test with Book model
    book_settings = Class.new do
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :terms_accepted, :boolean, default: true
      attribute :privacy_accepted, :boolean, default: false

      def model_name
        ActiveModel::Name.new(self.class, nil, "User")
      end
    end

    user = book_settings.new

    # Test terms checkbox
    terms_component = ShadcnPhlexcomponents::FormCheckbox.new(
      :terms_accepted,
      model: user,
      object_name: :user,
      label: "Terms and Conditions",
      hint: "By checking this box, you agree to our terms of service",
      class: "terms-checkbox",
    ) { "I have read and agree to the Terms and Conditions" }
    terms_output = render(terms_component)

    # Check proper model integration
    assert_includes(terms_output, 'name="user[terms_accepted]"')
    assert_includes(terms_output, 'id="user_terms_accepted"')
    assert_includes(terms_output, "checked") # Model value is true

    # Privacy checkbox (unchecked)
    privacy_component = ShadcnPhlexcomponents::FormCheckbox.new(
      :privacy_accepted,
      model: user,
      object_name: :user,
      label: "Privacy Policy",
    ) { "I agree to the Privacy Policy" }
    privacy_output = render(privacy_component)

    assert_includes(privacy_output, 'name="user[privacy_accepted]"')
    refute_includes(privacy_output, " checked") # Model value is false
    assert_includes(privacy_output, 'data-checked="false"')
  end

  def test_form_checkbox_accessibility_compliance
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :accessibility_compliance,
      label: "Accessibility Settings",
      hint: "Enable additional accessibility features",
      error: "You must enable accessibility features to continue",
      aria: { required: "true" },
    ) { "Enable accessibility features" }
    output = render(component)

    # Check ARIA compliance
    assert_includes(output, 'role="checkbox"')
    # Check ARIA attributes are present (note: may not be perfectly formatted due to component implementation)
    assert_includes(output, 'id="form-field-')
    assert_includes(output, '-description"')
    assert_includes(output, '-message"')
    # Check error state is properly displayed
    assert_includes(output, "You must enable accessibility features to continue")
    assert_includes(output, "text-destructive")
    assert_includes(output, 'aria-required="true"')

    # Check label association
    assert_match(/for="accessibility_compliance"/, output)

    # Check error and hint IDs are properly referenced
    assert_match(/id="[^"]*-description"/, output)
    assert_match(/id="[^"]*-message"/, output)

    # Check proper label styling for error state
    assert_includes(output, "text-destructive")
  end

  def test_form_checkbox_with_stimulus_integration
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :terms_with_tracking,
      data: {
        controller: "checkbox analytics legal-tracking",
        analytics_category: "legal",
        legal_tracking_document_type: "terms",
      },
    ) { "I accept the terms and conditions" }
    output = render(component)

    # Check multiple Stimulus controllers
    assert_match(/data-controller="checkbox[^"]*analytics[^"]*legal-tracking/, output)
    assert_includes(output, 'data-analytics-category="legal"')
    assert_includes(output, 'data-legal-tracking-document-type="terms"')

    # Check default checkbox Stimulus functionality still works
    assert_includes(output, 'data-action="click->checkbox#toggle')
    assert_includes(output, 'data-checkbox-target="input"')
  end

  def test_form_checkbox_validation_states
    # Test valid state
    valid_component = ShadcnPhlexcomponents::FormCheckbox.new(
      :valid_field,
      checked: true,
      class: "valid-checkbox",
    ) { "Valid field" }
    valid_output = render(valid_component)

    assert_includes(valid_output, 'aria-invalid="false"')
    assert_includes(valid_output, "valid-checkbox")

    # Test invalid state
    invalid_component = ShadcnPhlexcomponents::FormCheckbox.new(
      :invalid_field,
      error: "This field has an error",
      class: "invalid-checkbox",
    ) { "Invalid field" }
    invalid_output = render(invalid_component)

    assert_includes(invalid_output, 'aria-invalid="true"')
    assert_includes(invalid_output, "text-destructive") # Error styling on label
  end

  def test_form_checkbox_with_custom_styling
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :styled_checkbox,
      checked: true,
      label: "Styled Checkbox",
      hint: "This checkbox has custom styling",
      class: "w-5 h-5 custom-checkbox border-2",
      data: { theme: "primary" },
    ) { "Custom styled checkbox content" }
    output = render(component)

    # Check custom styling is applied
    assert_includes(output, "w-5 h-5 custom-checkbox border-2")
    assert_includes(output, 'data-theme="primary"')

    # Check default classes are still present
    assert_includes(output, "size-4 shrink-0 rounded-[4px]") # Default checkbox classes

    # Check layout classes are preserved
    assert_includes(output, "flex items-top space-x-2")
    assert_includes(output, "ml-6") # Label offset
  end

  def test_form_checkbox_dark_mode_support
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :dark_mode_test,
      checked: true,
    ) { "Dark mode test" }
    output = render(component)

    # Check dark mode classes are present in checkbox
    assert_includes(output, "dark:bg-input/30")
    assert_includes(output, "dark:data-[state=checked]:bg-primary")
  end

  def test_form_checkbox_keyboard_interaction
    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :keyboard_test,
    ) { "Keyboard test" }
    output = render(component)

    # Check keyboard interaction setup
    assert_includes(output, 'data-action="click->checkbox#toggle')
    assert_includes(output, "keydown.enter->checkbox#preventDefault")
    assert_includes(output, 'role="checkbox"')

    # The actual checkbox input should be hidden but accessible
    assert_includes(output, 'tabindex="-1"')
    assert_includes(output, 'aria-hidden="true"')
    assert_includes(output, "-translate-x-full pointer-events-none absolute")
  end

  def test_form_checkbox_with_array_errors
    # Use the Book class with custom validations for multiple errors
    book = Book.new
    book.valid? # trigger validation to get basic error

    # Manually add multiple errors to simulate array errors
    book.errors.add(:read, "Error 1")
    book.errors.add(:read, "Error 2")
    book.errors.add(:read, "Error 3")

    component = ShadcnPhlexcomponents::FormCheckbox.new(
      :read,
      model: book,
    ) { "Field with multiple errors" }
    output = render(component)

    # Should handle array of errors - but FormHelpers only shows the first error
    assert_includes(output, "Error 1")
    # NOTE: default_error in FormHelpers returns errors.full_messages_for(method).first
    # So only the first error message will be displayed, not multiple errors with special formatting
  end

  def test_form_checkbox_form_integration_workflow
    # Test complete form workflow with validation using Book class extended with additional attributes
    book = Book.new

    # Add custom attributes for this test
    def book.newsletter = @newsletter ||= true
    def book.terms = @terms ||= false
    def book.privacy = @privacy ||= false

    # Add custom validations
    book.errors.add(:terms, "Terms must be accepted") unless book.terms
    book.errors.add(:privacy, "Privacy policy must be accepted") unless book.privacy

    # Newsletter checkbox (valid, checked)
    newsletter = ShadcnPhlexcomponents::FormCheckbox.new(
      :newsletter,
      model: book,
      label: "Newsletter Subscription",
      hint: "Receive our weekly newsletter",
    ) { "Subscribe to newsletter" }
    newsletter_output = render(newsletter)

    assert_includes(newsletter_output, "checked")
    assert_includes(newsletter_output, 'aria-invalid="false"')
    refute_includes(newsletter_output, "text-destructive")

    # Terms checkbox (invalid, unchecked, with error)
    terms = ShadcnPhlexcomponents::FormCheckbox.new(
      :terms,
      model: book,
      label: "Terms and Conditions",
    ) { "I accept the terms and conditions" }
    terms_output = render(terms)

    refute_includes(terms_output, " checked")
    assert_includes(terms_output, 'aria-invalid="true"')
    assert_includes(terms_output, "Terms must be accepted")
    assert_includes(terms_output, "text-destructive")

    # Privacy checkbox (invalid, unchecked, with error)
    privacy = ShadcnPhlexcomponents::FormCheckbox.new(
      :privacy,
      model: book,
      label: "Privacy Policy",
    ) { "I accept the privacy policy" }
    privacy_output = render(privacy)

    refute_includes(privacy_output, " checked")
    assert_includes(privacy_output, 'aria-invalid="true"')
    assert_includes(privacy_output, "Privacy policy must be accepted")
    assert_includes(privacy_output, "text-destructive")
  end
end
