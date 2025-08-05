# frozen_string_literal: true

require "test_helper"

class TestFormError < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::FormError.new("This field is required")
    output = render(component)

    assert_includes(output, "This field is required")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
    assert_includes(output, "text-destructive text-sm")
    assert_match(%r{<p[^>]*>This field is required</p>}, output)
  end

  def test_it_should_render_with_aria_id
    component = ShadcnPhlexcomponents::FormError.new(
      "Field validation failed",
      aria_id: "test-field",
    )
    output = render(component)

    assert_includes(output, "Field validation failed")
    assert_includes(output, 'id="test-field-message"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::FormError.new(
      "Custom error message",
      class: "custom-error",
      data: { testid: "error-message" },
    )
    output = render(component)

    assert_includes(output, "Custom error message")
    assert_includes(output, "custom-error")
    assert_includes(output, 'data-testid="error-message"')
    assert_includes(output, "text-destructive text-sm") # Default classes should still be present
  end

  def test_it_should_render_with_block_content
    component = ShadcnPhlexcomponents::FormError.new(nil) do
      "Block content error message"
    end
    output = render(component)

    assert_includes(output, "Block content error message")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
    assert_includes(output, "text-destructive text-sm")
  end

  def test_it_should_render_with_aria_id_and_block_content
    component = ShadcnPhlexcomponents::FormError.new(
      nil,
      aria_id: "block-test",
    ) do
      "Block error with ARIA ID"
    end
    output = render(component)

    assert_includes(output, "Block error with ARIA ID")
    assert_includes(output, 'id="block-test-message"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
  end

  def test_it_should_render_complex_html_content
    component = ShadcnPhlexcomponents::FormError.new("Error: Field is required")
    output = render(component)

    assert_includes(output, "Error: Field is required")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
    assert_includes(output, "text-destructive text-sm")
  end

  def test_it_should_handle_empty_message
    component = ShadcnPhlexcomponents::FormError.new("")
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
    assert_includes(output, "text-destructive text-sm")
    assert_match(%r{<p[^>]*></p>}, output) # Empty paragraph
  end

  def test_it_should_handle_nil_message_without_block
    component = ShadcnPhlexcomponents::FormError.new(nil)
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
    assert_includes(output, "text-destructive text-sm")
    assert_match(%r{<p[^>]*></p>}, output) # Empty paragraph
  end

  def test_it_should_handle_html_in_message
    component = ShadcnPhlexcomponents::FormError.new(
      "Email <strong>must be valid</strong>",
    )
    output = render(component)

    # HTML should be escaped for security
    assert_includes(output, "Email &lt;strong&gt;must be valid&lt;/strong&gt;")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
  end

  def test_it_should_handle_special_characters
    component = ShadcnPhlexcomponents::FormError.new(
      "Password can't contain special characters: &<>\"'",
    )
    output = render(component)

    # Special characters should be properly escaped
    assert_includes(output, "can&#39;t")
    assert_includes(output, "&amp;&lt;&gt;&quot;&#39;")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
  end

  def test_it_should_merge_classes_properly
    component = ShadcnPhlexcomponents::FormError.new(
      "Merge test",
      class: "additional-class another-class",
    )
    output = render(component)

    assert_includes(output, "text-destructive text-sm") # Default classes
    assert_includes(output, "additional-class another-class") # Custom classes
    assert_includes(output, "Merge test")
  end

  def test_it_should_handle_long_error_messages
    long_message = "This is a very long error message that contains multiple sentences and should be properly displayed. " * 5

    component = ShadcnPhlexcomponents::FormError.new(long_message)
    output = render(component)

    assert_includes(output, long_message)
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
    assert_includes(output, "text-destructive text-sm")
  end

  def test_it_should_render_with_custom_id
    component = ShadcnPhlexcomponents::FormError.new(
      "Custom ID test",
      id: "custom-error-id",
    )
    output = render(component)

    assert_includes(output, "Custom ID test")
    assert_includes(output, 'id="custom-error-id"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
  end

  def test_it_should_prioritize_custom_id_over_aria_id
    component = ShadcnPhlexcomponents::FormError.new(
      "ID priority test",
      id: "custom-id",
      aria_id: "aria-field",
    )
    output = render(component)

    assert_includes(output, "ID priority test")
    assert_includes(output, 'id="custom-id"')
    refute_includes(output, 'id="aria-field-message"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
  end

  def test_it_should_handle_multiple_data_attributes
    component = ShadcnPhlexcomponents::FormError.new(
      "Multiple data attributes",
      data: {
        testid: "error-message",
        analytics: "form-error",
        field: "username",
        level: "critical",
      },
    )
    output = render(component)

    assert_includes(output, "Multiple data attributes")
    assert_includes(output, 'data-testid="error-message"')
    assert_includes(output, 'data-analytics="form-error"')
    assert_includes(output, 'data-field="username"')
    assert_includes(output, 'data-level="critical"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
  end

  def test_it_should_work_with_form_integration
    # Simulate how FormError is used within other form components
    aria_id = "form-field-abc123"

    component = ShadcnPhlexcomponents::FormError.new(
      "Username is already taken",
      aria_id: aria_id,
    )
    output = render(component)

    assert_includes(output, "Username is already taken")
    assert_includes(output, 'id="form-field-abc123-message"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
    assert_includes(output, "text-destructive text-sm")
  end
end

class TestFormErrorWithCustomConfiguration < ComponentTest
  def test_form_error_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.form = {
      error: { base: "custom-error-base text-red-600" },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload FormError class
    if ShadcnPhlexcomponents.const_defined?(:FormError)
      ShadcnPhlexcomponents.send(:remove_const, :FormError)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/form/form_error.rb", __dir__))

    # Test component with custom configuration
    error = ShadcnPhlexcomponents::FormError.new("Custom config test")
    output = render(error)

    assert_includes(output, "custom-error-base text-red-600")
    assert_includes(output, "Custom config test")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    if ShadcnPhlexcomponents.const_defined?(:FormError)
      ShadcnPhlexcomponents.send(:remove_const, :FormError)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/form/form_error.rb", __dir__))
  end
end

class TestFormErrorIntegration < ComponentTest
  def test_form_error_in_form_field_context
    # Test how FormError integrates with form fields and accessibility
    error_component = ShadcnPhlexcomponents::FormError.new(
      "This field contains errors",
      aria_id: "username-field",
      class: "form-validation-error",
      data: {
        field: "username",
        severity: "error",
        controller: "form-validation",
      },
    )
    output = render(error_component)

    # Check proper integration attributes
    assert_includes(output, "This field contains errors")
    assert_includes(output, 'id="username-field-message"')
    assert_includes(output, "form-validation-error")
    assert_includes(output, 'data-field="username"')
    assert_includes(output, 'data-severity="error"')
    assert_includes(output, 'data-controller="form-validation"')

    # Check accessibility compliance
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
    assert_includes(output, "text-destructive text-sm")
  end

  def test_form_error_with_array_errors
    # Test handling of multiple error messages as a single string
    errors = ["Username is required", "Username must be at least 3 characters", "Username is already taken"]
    combined_message = errors.join(", ")

    error_component = ShadcnPhlexcomponents::FormError.new(combined_message, aria_id: "multi-error")
    output = render(error_component)

    errors.each do |err|
      assert_includes(output, err)
    end
    assert_includes(output, 'id="multi-error-message"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
  end

  def test_form_error_styling_variants
    # Test different error styling approaches
    warning_error = ShadcnPhlexcomponents::FormError.new(
      "This is a warning",
      class: "text-yellow-600 border-l-4 border-yellow-400 pl-3",
    )
    warning_output = render(warning_error)

    critical_error = ShadcnPhlexcomponents::FormError.new(
      "This is critical",
      class: "text-red-800 bg-red-50 p-2 rounded border",
    )
    critical_output = render(critical_error)

    # Check warning styling
    assert_includes(warning_output, "text-yellow-600 border-l-4 border-yellow-400 pl-3")
    assert_includes(warning_output, "text-destructive text-sm") # Default classes still present
    assert_includes(warning_output, "This is a warning")

    # Check critical styling
    assert_includes(critical_output, "text-red-800 bg-red-50 p-2 rounded border")
    assert_includes(critical_output, "text-destructive text-sm") # Default classes still present
    assert_includes(critical_output, "This is critical")
  end

  def test_form_error_accessibility_features
    error_component = ShadcnPhlexcomponents::FormError.new(
      "Accessibility test error",
      aria_id: "accessible-field",
      role: "alert",
      "aria-live": "polite",
    )
    output = render(error_component)

    # Check accessibility attributes
    assert_includes(output, "Accessibility test error")
    assert_includes(output, 'id="accessible-field-message"')
    assert_includes(output, 'role="alert"')
    assert_includes(output, 'aria-live="polite"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
  end

  def test_form_error_with_internationalization
    # Test error messages that might come from I18n
    i18n_messages = [
      "Le nom d'utilisateur est requis", # French
      "用户名是必需的", # Chinese
      "اسم المستخدم مطلوب", # Arabic
      "Имя пользователя обязательно", # Russian
    ]

    i18n_messages.each_with_index do |message, index|
      component = ShadcnPhlexcomponents::FormError.new(
        message,
        aria_id: "i18n-test-#{index}",
      )
      output = render(component)

      # HTML encoding will change apostrophes
      if message.include?("'")
        encoded_message = message.gsub("'", "&#39;")
        assert_includes(output, encoded_message)
      else
        assert_includes(output, message)
      end
      assert_includes(output, "id=\"i18n-test-#{index}-message\"")
      assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
    end
  end

  def test_form_error_performance_with_large_content
    # Test with large error content to ensure no performance issues
    large_content = "Error: " + ("Very long error message with lots of detail. " * 100)

    component = ShadcnPhlexcomponents::FormError.new(large_content)
    output = render(component)

    assert_includes(output, large_content)
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
    assert_includes(output, "text-destructive text-sm")

    # Ensure the output is properly formed HTML
    assert_match(%r{<p[^>]*>.*</p>}, output)
  end

  def test_form_error_with_stimulus_integration
    error_component = ShadcnPhlexcomponents::FormError.new(
      "Field validation failed",
      data: {
        controller: "form-error auto-hide",
        auto_hide_delay_value: 5000,
        form_error_target: "message",
      },
    )
    output = render(error_component)

    # Check Stimulus integration
    assert_includes(output, "Field validation failed")
    assert_match(/data-controller="[^"]*form-error[^"]*auto-hide/, output)
    assert_includes(output, 'data-auto-hide-delay-value="5000"')
    assert_includes(output, 'data-form-error-target="message"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
  end

  def test_form_error_semantic_html_structure
    # Test that FormError produces semantic HTML
    component = ShadcnPhlexcomponents::FormError.new(
      "Semantic HTML test",
      aria_id: "semantic-test",
    )
    output = render(component)

    # Should be a paragraph element for semantic correctness
    assert_match(%r{^<p[^>]*>.*</p>$}, output.strip)
    assert_includes(output, "Semantic HTML test")
    assert_includes(output, 'id="semantic-test-message"')

    # Should not contain any divs or other non-semantic elements at the root
    refute_match(/^<div/, output.strip)
    refute_match(/^<span/, output.strip)
  end
end
