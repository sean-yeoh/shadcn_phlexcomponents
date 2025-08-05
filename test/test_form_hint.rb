# frozen_string_literal: true

require "test_helper"

class TestFormHint < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::FormHint.new("This is a helpful hint")
    output = render(component)

    assert_includes(output, "This is a helpful hint")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
    assert_includes(output, "text-muted-foreground text-sm")
    assert_match(%r{<p[^>]*>This is a helpful hint</p>}, output)
  end

  def test_it_should_render_with_aria_id
    component = ShadcnPhlexcomponents::FormHint.new(
      "Helpful guidance text",
      aria_id: "test-field",
    )
    output = render(component)

    assert_includes(output, "Helpful guidance text")
    assert_includes(output, 'id="test-field-description"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::FormHint.new(
      "Custom hint message",
      class: "custom-hint",
      data: { testid: "hint-message" },
    )
    output = render(component)

    assert_includes(output, "Custom hint message")
    assert_includes(output, "custom-hint")
    assert_includes(output, 'data-testid="hint-message"')
    assert_includes(output, "text-muted-foreground text-sm") # Default classes should still be present
  end

  def test_it_should_render_with_block_content
    component = ShadcnPhlexcomponents::FormHint.new(nil) do
      "Block content hint message"
    end
    output = render(component)

    assert_includes(output, "Block content hint message")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
    assert_includes(output, "text-muted-foreground text-sm")
  end

  def test_it_should_render_with_aria_id_and_block_content
    component = ShadcnPhlexcomponents::FormHint.new(
      nil,
      aria_id: "block-test",
    ) do
      "Block hint with ARIA ID"
    end
    output = render(component)

    assert_includes(output, "Block hint with ARIA ID")
    assert_includes(output, 'id="block-test-description"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
  end

  def test_it_should_render_complex_html_content
    component = ShadcnPhlexcomponents::FormHint.new("Hint: Use at least 8 characters")
    output = render(component)

    assert_includes(output, "Hint: Use at least 8 characters")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
    assert_includes(output, "text-muted-foreground text-sm")
  end

  def test_it_should_handle_empty_message
    component = ShadcnPhlexcomponents::FormHint.new("")
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
    assert_includes(output, "text-muted-foreground text-sm")
    assert_match(%r{<p[^>]*></p>}, output) # Empty paragraph
  end

  def test_it_should_handle_nil_message_without_block
    component = ShadcnPhlexcomponents::FormHint.new(nil)
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
    assert_includes(output, "text-muted-foreground text-sm")
    assert_match(%r{<p[^>]*></p>}, output) # Empty paragraph
  end

  def test_it_should_handle_html_in_message
    component = ShadcnPhlexcomponents::FormHint.new(
      "Password must be <strong>at least 8 characters</strong>",
    )
    output = render(component)

    # HTML should be escaped for security
    assert_includes(output, "Password must be &lt;strong&gt;at least 8 characters&lt;/strong&gt;")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
  end

  def test_it_should_handle_special_characters
    component = ShadcnPhlexcomponents::FormHint.new(
      "Password can contain special characters: &<>\"'",
    )
    output = render(component)

    # Special characters should be properly escaped
    assert_includes(output, "&amp;&lt;&gt;&quot;&#39;")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
  end

  def test_it_should_merge_classes_properly
    component = ShadcnPhlexcomponents::FormHint.new(
      "Merge test",
      class: "additional-class another-class",
    )
    output = render(component)

    assert_includes(output, "text-muted-foreground text-sm") # Default classes
    assert_includes(output, "additional-class another-class") # Custom classes
    assert_includes(output, "Merge test")
  end

  def test_it_should_handle_long_hint_messages
    long_message = "This is a very long hint message that contains multiple sentences and should be properly displayed. " * 5

    component = ShadcnPhlexcomponents::FormHint.new(long_message)
    output = render(component)

    assert_includes(output, long_message)
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
    assert_includes(output, "text-muted-foreground text-sm")
  end

  def test_it_should_render_with_custom_id
    component = ShadcnPhlexcomponents::FormHint.new(
      "Custom ID test",
      id: "custom-hint-id",
    )
    output = render(component)

    assert_includes(output, "Custom ID test")
    assert_includes(output, 'id="custom-hint-id"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
  end

  def test_it_should_prioritize_custom_id_over_aria_id
    component = ShadcnPhlexcomponents::FormHint.new(
      "ID priority test",
      id: "custom-id",
      aria_id: "aria-field",
    )
    output = render(component)

    assert_includes(output, "ID priority test")
    assert_includes(output, 'id="custom-id"')
    refute_includes(output, 'id="aria-field-description"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
  end

  def test_it_should_handle_multiple_data_attributes
    component = ShadcnPhlexcomponents::FormHint.new(
      "Multiple data attributes",
      data: {
        testid: "hint-message",
        analytics: "form-hint",
        field: "username",
        level: "info",
      },
    )
    output = render(component)

    assert_includes(output, "Multiple data attributes")
    assert_includes(output, 'data-testid="hint-message"')
    assert_includes(output, 'data-analytics="form-hint"')
    assert_includes(output, 'data-field="username"')
    assert_includes(output, 'data-level="info"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
  end

  def test_it_should_work_with_form_integration
    # Simulate how FormHint is used within other form components
    aria_id = "form-field-abc123"

    component = ShadcnPhlexcomponents::FormHint.new(
      "Enter your username here",
      aria_id: aria_id,
    )
    output = render(component)

    assert_includes(output, "Enter your username here")
    assert_includes(output, 'id="form-field-abc123-description"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
    assert_includes(output, "text-muted-foreground text-sm")
  end
end

class TestFormHintWithCustomConfiguration < ComponentTest
  def test_form_hint_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.form = {
      hint: { base: "custom-hint-base text-gray-500" },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload FormHint class
    if ShadcnPhlexcomponents.const_defined?(:FormHint)
      ShadcnPhlexcomponents.send(:remove_const, :FormHint)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/form/form_hint.rb", __dir__))

    # Test component with custom configuration
    hint = ShadcnPhlexcomponents::FormHint.new("Custom config test")
    output = render(hint)

    assert_includes(output, "custom-hint-base text-gray-500")
    assert_includes(output, "Custom config test")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    if ShadcnPhlexcomponents.const_defined?(:FormHint)
      ShadcnPhlexcomponents.send(:remove_const, :FormHint)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/form/form_hint.rb", __dir__))
  end
end

class TestFormHintIntegration < ComponentTest
  def test_form_hint_in_form_field_context
    # Test how FormHint integrates with form fields and accessibility
    hint_component = ShadcnPhlexcomponents::FormHint.new(
      "This field provides helpful guidance",
      aria_id: "username-field",
      class: "form-guidance-hint",
      data: {
        field: "username",
        type: "guidance",
        controller: "form-help",
      },
    )
    output = render(hint_component)

    # Check proper integration attributes
    assert_includes(output, "This field provides helpful guidance")
    assert_includes(output, 'id="username-field-description"')
    assert_includes(output, "form-guidance-hint")
    assert_includes(output, 'data-field="username"')
    assert_includes(output, 'data-type="guidance"')
    assert_includes(output, 'data-controller="form-help"')

    # Check accessibility compliance
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
    assert_includes(output, "text-muted-foreground text-sm")
  end

  def test_form_hint_with_internationalization
    # Test hint messages that might come from I18n
    i18n_messages = [
      "Entrez votre nom d'utilisateur", # French
      "输入您的用户名", # Chinese
      "أدخل اسم المستخدم", # Arabic
      "Введите имя пользователя", # Russian
    ]

    i18n_messages.each_with_index do |message, index|
      component = ShadcnPhlexcomponents::FormHint.new(
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
      assert_includes(output, "id=\"i18n-test-#{index}-description\"")
      assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
    end
  end

  def test_form_hint_styling_variants
    # Test different hint styling approaches
    info_hint = ShadcnPhlexcomponents::FormHint.new(
      "This is informational",
      class: "text-blue-600 border-l-4 border-blue-400 pl-3",
    )
    info_output = render(info_hint)

    subtle_hint = ShadcnPhlexcomponents::FormHint.new(
      "This is subtle guidance",
      class: "text-gray-400 italic",
    )
    subtle_output = render(subtle_hint)

    # Check info styling
    assert_includes(info_output, "text-blue-600 border-l-4 border-blue-400 pl-3")
    assert_includes(info_output, "text-muted-foreground text-sm") # Default classes still present
    assert_includes(info_output, "This is informational")

    # Check subtle styling
    assert_includes(subtle_output, "text-gray-400 italic")
    assert_includes(subtle_output, "text-muted-foreground text-sm") # Default classes still present
    assert_includes(subtle_output, "This is subtle guidance")
  end

  def test_form_hint_accessibility_features
    hint_component = ShadcnPhlexcomponents::FormHint.new(
      "Accessibility test hint",
      aria_id: "accessible-field",
      role: "note",
      "aria-live": "polite",
    )
    output = render(hint_component)

    # Check accessibility attributes
    assert_includes(output, "Accessibility test hint")
    assert_includes(output, 'id="accessible-field-description"')
    assert_includes(output, 'role="note"')
    assert_includes(output, 'aria-live="polite"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
  end

  def test_form_hint_performance_with_large_content
    # Test with large hint content to ensure no performance issues
    large_content = "Hint: " + ("Very long helpful guidance with lots of detail. " * 100)

    component = ShadcnPhlexcomponents::FormHint.new(large_content)
    output = render(component)

    assert_includes(output, large_content)
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
    assert_includes(output, "text-muted-foreground text-sm")

    # Ensure the output is properly formed HTML
    assert_match(%r{<p[^>]*>.*</p>}, output)
  end

  def test_form_hint_with_stimulus_integration
    hint_component = ShadcnPhlexcomponents::FormHint.new(
      "Interactive hint with help",
      data: {
        controller: "form-hint tooltip",
        tooltip_text: "Additional information",
        form_hint_target: "content",
      },
    )
    output = render(hint_component)

    # Check Stimulus integration
    assert_includes(output, "Interactive hint with help")
    assert_match(/data-controller="[^"]*form-hint[^"]*tooltip/, output)
    assert_includes(output, 'data-tooltip-text="Additional information"')
    assert_includes(output, 'data-form-hint-target="content"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
  end

  def test_form_hint_semantic_html_structure
    # Test that FormHint produces semantic HTML
    component = ShadcnPhlexcomponents::FormHint.new(
      "Semantic HTML test",
      aria_id: "semantic-test",
    )
    output = render(component)

    # Should be a paragraph element for semantic correctness
    assert_match(%r{^<p[^>]*>.*</p>$}, output.strip)
    assert_includes(output, "Semantic HTML test")
    assert_includes(output, 'id="semantic-test-description"')

    # Should not contain any divs or other non-semantic elements at the root
    refute_match(/^<div/, output.strip)
    refute_match(/^<span/, output.strip)
  end

  def test_form_hint_with_markdown_like_content
    # Test hints that might contain formatting instructions
    markdown_hint = ShadcnPhlexcomponents::FormHint.new(
      "Use **bold** text for emphasis and *italic* for subtlety",
    )
    output = render(markdown_hint)

    # Markdown should be escaped, not processed
    assert_includes(output, "Use **bold** text for emphasis and *italic* for subtlety")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
  end

  def test_form_hint_tooltip_integration
    # Test hints that work well with tooltip systems
    tooltip_hint = ShadcnPhlexcomponents::FormHint.new(
      "Click for more information",
      aria_id: "tooltip-field",
      data: {
        tooltip: true,
        tooltip_content: "Extended help information",
        tooltip_position: "top",
      },
      class: "cursor-help underline decoration-dotted",
    )
    output = render(tooltip_hint)

    assert_includes(output, "Click for more information")
    assert_includes(output, 'id="tooltip-field-description"')
    assert_includes(output, "data-tooltip")
    assert_includes(output, 'data-tooltip-content="Extended help information"')
    assert_includes(output, 'data-tooltip-position="top"')
    assert_includes(output, "cursor-help underline decoration-dotted")
  end
end
