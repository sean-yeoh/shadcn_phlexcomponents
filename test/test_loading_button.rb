# frozen_string_literal: true

require "test_helper"

class TestLoadingButton < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::LoadingButton.new { "Loading button content" }
    output = render(component)

    assert_includes(output, "Loading button content")
    assert_includes(output, 'data-shadcn-phlexcomponents="loading-button button"')
    assert_includes(output, 'type="submit"')
    assert_includes(output, 'data-controller="loading-button"')
    assert_match(%r{<button[^>]*>.*Loading button content.*</button>}m, output)
  end

  def test_it_should_render_with_default_variant_and_size
    component = ShadcnPhlexcomponents::LoadingButton.new { "Default button" }
    output = render(component)

    assert_includes(output, "Default button")
    assert_includes(output, 'type="submit"')
    # Should include default button styling from Button component
    assert_includes(output, "inline-flex items-center justify-center")
  end

  def test_it_should_render_with_custom_variant
    component = ShadcnPhlexcomponents::LoadingButton.new(variant: :outline) { "Outline button" }
    output = render(component)

    assert_includes(output, "Outline button")
    # Should include outline variant styling
    assert_includes(output, "border")
  end

  def test_it_should_render_with_custom_size
    component = ShadcnPhlexcomponents::LoadingButton.new(size: :lg) { "Large button" }
    output = render(component)

    assert_includes(output, "Large button")
    # Should include large size styling
    assert_includes(output, "h-10")
    assert_includes(output, "px-6")
  end

  def test_it_should_render_with_custom_type
    component = ShadcnPhlexcomponents::LoadingButton.new(type: :button) { "Button type" }
    output = render(component)

    assert_includes(output, "Button type")
    assert_includes(output, 'type="button"')
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::LoadingButton.new(
      class: "custom-loading-button",
      id: "loading-btn-id",
      data: { testid: "loading-button" },
    ) { "Custom button" }
    output = render(component)

    assert_includes(output, "custom-loading-button")
    assert_includes(output, 'id="loading-btn-id"')
    assert_includes(output, 'data-testid="loading-button"')
    assert_includes(output, "Custom button")
  end

  def test_it_should_include_loading_spinner
    component = ShadcnPhlexcomponents::LoadingButton.new { "Save Changes" }
    output = render(component)

    # Check for loader-circle icon
    assert_match(%r{<svg[^>]*>.*</svg>}m, output)
    assert_includes(output, "animate-spin")
    assert_includes(output, "hidden")
    assert_includes(output, "group-aria-busy:inline")
    assert_includes(output, "Save Changes")
  end

  def test_it_should_handle_different_variants
    variants = [:default, :destructive, :outline, :secondary, :ghost, :link]

    variants.each do |variant|
      component = ShadcnPhlexcomponents::LoadingButton.new(variant: variant) { "#{variant.to_s.capitalize} Button" }
      output = render(component)

      assert_includes(output, "#{variant.to_s.capitalize} Button")
      assert_includes(output, 'data-controller="loading-button"')
    end
  end

  def test_it_should_handle_different_sizes
    sizes = [:default, :sm, :lg, :icon]

    sizes.each do |size|
      component = ShadcnPhlexcomponents::LoadingButton.new(size: size) { "#{size.to_s.capitalize} Button" }
      output = render(component)

      assert_includes(output, "#{size.to_s.capitalize} Button")
      assert_includes(output, 'data-controller="loading-button"')
    end
  end

  def test_it_should_handle_different_types
    types = [:submit, :button, :reset]

    types.each do |type|
      component = ShadcnPhlexcomponents::LoadingButton.new(type: type) { "#{type.to_s.capitalize} Button" }
      output = render(component)

      assert_includes(output, "#{type.to_s.capitalize} Button")
      assert_includes(output, "type=\"#{type}\"")
    end
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::LoadingButton.new(disabled: true) { "Disabled Button" }
    output = render(component)

    assert_includes(output, "Disabled Button")
    assert_includes(output, "disabled")
    assert_includes(output, "disabled:pointer-events-none")
    assert_includes(output, "disabled:opacity-50")
  end

  def test_it_should_handle_aria_attributes
    component = ShadcnPhlexcomponents::LoadingButton.new(
      aria: {
        label: "Submit form",
        describedby: "submit-help",
      },
    ) { "Submit" }
    output = render(component)

    assert_includes(output, 'aria-label="Submit form"')
    assert_includes(output, 'aria-describedby="submit-help"')
    assert_includes(output, "Submit")
  end

  def test_it_should_handle_data_attributes
    component = ShadcnPhlexcomponents::LoadingButton.new(
      data: {
        form_target: "submit",
        action: "click->form#submitWithLoading",
      },
    ) { "Submit Form" }
    output = render(component)

    # Should merge with default loading-button controller
    assert_includes(output, 'data-controller="loading-button"')
    assert_includes(output, 'data-form-target="submit"')
    assert_includes(output, "submitWithLoading")
  end

  def test_it_should_support_form_integration
    component = ShadcnPhlexcomponents::LoadingButton.new(
      form: "user-form",
      formaction: "/users",
      formmethod: "post",
    ) { "Create User" }
    output = render(component)

    assert_includes(output, 'form="user-form"')
    assert_includes(output, 'formaction="/users"')
    assert_includes(output, 'formmethod="post"')
    assert_includes(output, "Create User")
  end

  def test_it_should_handle_name_and_value_attributes
    component = ShadcnPhlexcomponents::LoadingButton.new(
      name: "commit",
      value: "save_draft",
    ) { "Save as Draft" }
    output = render(component)

    assert_includes(output, 'name="commit"')
    assert_includes(output, 'value="save_draft"')
    assert_includes(output, "Save as Draft")
  end
end

class TestLoadingButtonIntegration < ComponentTest
  def test_complete_loading_button_workflow
    component = ShadcnPhlexcomponents::LoadingButton.new(
      variant: :default,
      size: :default,
      type: :submit,
      class: "form-submit-btn",
      id: "submit-button",
      aria: {
        label: "Submit user registration form",
        describedby: "submit-help",
      },
      data: {
        controller: "loading-button form-validation",
        form_validation_target: "submitButton",
        action: "click->form-validation#validateAndSubmit",
      },
    ) { "💾 Create Account" }

    output = render(component)

    # Check main structure
    assert_includes(output, "form-submit-btn")
    assert_includes(output, 'id="submit-button"')
    assert_includes(output, 'type="submit"')

    # Check content with emoji
    assert_includes(output, "💾 Create Account")

    # Check accessibility
    assert_includes(output, 'aria-label="Submit user registration form"')
    assert_includes(output, 'aria-describedby="submit-help"')

    # Check stimulus integration
    assert_match(/data-controller="[^"]*loading-button[^"]*form-validation[^"]*"/, output)
    assert_includes(output, 'data-form-validation-target="submitButton"')
    assert_includes(output, "validateAndSubmit")

    # Check loading spinner
    assert_includes(output, "animate-spin")
    assert_includes(output, "hidden")
    assert_includes(output, "group-aria-busy:inline")
  end

  def test_loading_button_accessibility_features
    component = ShadcnPhlexcomponents::LoadingButton.new(
      aria: {
        label: "Save document",
        describedby: "save-help save-status",
      },
      title: "Click to save the current document",
    ) { "💾 Save Document" }

    output = render(component)

    # Check accessibility attributes
    assert_includes(output, 'aria-label="Save document"')
    assert_includes(output, 'aria-describedby="save-help save-status"')
    assert_includes(output, 'title="Click to save the current document"')

    # Check content
    assert_includes(output, "💾 Save Document")

    # Check button role and type
    assert_includes(output, 'type="submit"')
  end

  def test_loading_button_form_integration
    component = ShadcnPhlexcomponents::LoadingButton.new(
      type: :submit,
      form: "payment-form",
      name: "action",
      value: "process_payment",
      data: {
        controller: "loading-button payment-processor",
        action: "click->payment-processor#processPayment",
      },
    ) { "💳 Process Payment" }

    output = render(component)

    # Check form integration
    assert_includes(output, 'type="submit"')
    assert_includes(output, 'form="payment-form"')
    assert_includes(output, 'name="action"')
    assert_includes(output, 'value="process_payment"')

    # Check content with emoji
    assert_includes(output, "💳 Process Payment")

    # Check stimulus integration
    assert_match(/data-controller="[^"]*loading-button[^"]*payment-processor[^"]*"/, output)
    assert_includes(output, "processPayment")
  end

  def test_loading_button_variant_integration
    component = ShadcnPhlexcomponents::LoadingButton.new(
      variant: :destructive,
      size: :lg,
      type: :button,
      class: "danger-action",
      data: {
        controller: "loading-button confirmation",
        action: "click->confirmation#confirmDelete",
      },
    ) { "🗑️ Delete Account" }

    output = render(component)

    # Check variant styling
    assert_includes(output, "danger-action")
    assert_includes(output, 'type="button"')

    # Check content with emoji
    assert_includes(output, "🗑️ Delete Account")

    # Check stimulus integration
    assert_match(/data-controller="[^"]*loading-button[^"]*confirmation[^"]*"/, output)
    assert_includes(output, "confirmDelete")

    # Check destructive variant styling
    assert_includes(output, "bg-destructive")
    assert_includes(output, "text-white")

    # Check large size styling
    assert_includes(output, "h-10")
    assert_includes(output, "px-6")
  end

  def test_loading_button_stimulus_integration
    component = ShadcnPhlexcomponents::LoadingButton.new(
      data: {
        controller: "loading-button auto-save",
        auto_save_interval_value: "30000",
        action: "click->auto-save#saveNow",
      },
    ) { "💾 Auto-Save" }

    output = render(component)

    # Check multiple controllers
    assert_match(/data-controller="[^"]*loading-button[^"]*auto-save[^"]*"/, output)
    assert_includes(output, 'data-auto-save-interval-value="30000"')

    # Check actions
    assert_includes(output, "saveNow")

    # Check content
    assert_includes(output, "💾 Auto-Save")

    # Check default loading button controller is present
    assert_includes(output, "loading-button")
  end

  def test_loading_button_with_complex_workflow
    component = ShadcnPhlexcomponents::LoadingButton.new(
      variant: :outline,
      size: :default,
      type: :submit,
      class: "upload-btn",
      disabled: false,
      data: {
        controller: "loading-button file-upload progress-tracker",
        file_upload_target: "submitButton",
        action: "click->file-upload#startUpload click->progress-tracker#track",
      },
    ) { "📤 Upload Files" }

    output = render(component)

    # Check structure
    assert_includes(output, "upload-btn")
    assert_includes(output, 'type="submit"')

    # Check content with emoji
    assert_includes(output, "📤 Upload Files")

    # Check multiple stimulus controllers
    assert_match(/data-controller="[^"]*loading-button[^"]*file-upload[^"]*progress-tracker[^"]*"/, output)
    assert_includes(output, 'data-file-upload-target="submitButton"')
    assert_includes(output, "startUpload")
    assert_includes(output, "track")

    # Check outline variant styling
    assert_includes(output, "border")
    assert_includes(output, "bg-background")

    # Check loading spinner
    assert_includes(output, "animate-spin")
    assert_includes(output, "group-aria-busy:inline")
  end

  def test_loading_button_disabled_state_integration
    component = ShadcnPhlexcomponents::LoadingButton.new(
      disabled: true,
      aria: {
        label: "Submit form (disabled)",
        describedby: "form-errors",
      },
    ) { "⏳ Processing..." }

    output = render(component)

    # Check disabled state
    assert_includes(output, "disabled")
    assert_includes(output, "disabled:pointer-events-none")
    assert_includes(output, "disabled:opacity-50")

    # Check accessibility for disabled state
    assert_includes(output, 'aria-label="Submit form (disabled)"')
    assert_includes(output, 'aria-describedby="form-errors"')

    # Check content
    assert_includes(output, "⏳ Processing...")

    # Check that loading button controller is still present
    assert_includes(output, 'data-controller="loading-button"')
  end
end
